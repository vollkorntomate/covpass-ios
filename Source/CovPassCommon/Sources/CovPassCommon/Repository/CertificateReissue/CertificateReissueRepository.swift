//
//  CertificateReissueRepository.swift
//  
//
//  Created by Thomas Kuleßa on 17.02.22.
//

import Foundation
import PromiseKit

private enum Constants {
    static let reissuePath = "/api/certify/v2/reissue"
    static let httpPostMethod = "POST"
}

public class CertificateReissueRepository: CertificateReissueRepositoryProtocol {
    private let jsonDecoder: JSONDecoder
    private let jsonEncoder: JSONEncoder
    private let reissueURL: URL
    private let trustList: TrustList
    private let httpClient: HTTPClientProtocol

    public init(baseURL: URL, jsonDecoder: JSONDecoder, jsonEncoder: JSONEncoder, trustList: TrustList, httpClient: HTTPClientProtocol) {
        reissueURL = baseURL.appendingPathComponent(Constants.reissuePath)
        self.jsonDecoder = jsonDecoder
        self.jsonEncoder = jsonEncoder
        self.httpClient = httpClient
        self.trustList = trustList
    }

    public func renew(_ webTokens: [ExtendedCBORWebToken]) -> Promise<CertificateReissueRepositoryResponse> {
        reissue(webTokens.map(\.vaccinationQRCodeData).certificateRenewRequestBody)
    }
    
    public func extend(_ webTokens: [ExtendedCBORWebToken]) -> Promise<CertificateReissueRepositoryResponse> {
        reissue(webTokens.map(\.vaccinationQRCodeData).certificateExtendRequestBody)
    }
    
    private func reissue(_ certificateExtendRequestBody: CertificateReissueRequestBody) -> Promise<CertificateReissueRepositoryResponse> {
        Promise { seal in
            jsonEncoder
                .encodePromise(certificateExtendRequestBody)
                .map(reissueRequest)
                .then(httpClient.httpRequest)
                .then(jsonDecoder.decodePromise)
                .then(certificateReissueRepositoryResponse)
                .done { seal.fulfill($0) }
                .catch { error in
                    seal.reject(
                        self.certificateReissueRepositoryError(from: error)
                    )
                }
        }
    }

    private func reissueRequest(_ body: Data) -> URLRequest {
        var request = URLRequest(url: reissueURL)
        request.httpMethod = Constants.httpPostMethod
        request.httpBody = body
        return request
    }

    private func certificateReissueRepositoryResponse(_ response: [CertificateReissueResponse]) -> Promise<CertificateReissueRepositoryResponse> {
        let promises = response.map(cborWebToken)
        return when(fulfilled: promises)
    }

    private func cborWebToken(from response: CertificateReissueResponse) -> Promise<ExtendedCBORWebToken> {
        response.certificate
            .stripPrefix()
            .decodedBase45
            .then(\.decompressed)
            .then(CoseSign1Message.promise)
            .then(verifiedCBORWebToken)
            .map { cborWebToken in
                ExtendedCBORWebToken(
                    vaccinationCertificate: cborWebToken,
                    vaccinationQRCodeData: response.certificate
                )
            }
    }

    private func verifiedCBORWebToken(_ coseSign1Message: CoseSign1Message) -> Promise<CBORWebToken> {
        when(fulfilled: cborWebToken(from: coseSign1Message),
             HCert.verifyPromise(message: coseSign1Message, trustList: trustList)
        )
        .then(checkExtendedKeyUsage)
        .then(\.noFraud)
        .then(\.notExpired)
    }

    private func cborWebToken(from coseSign1Message: CoseSign1Message) -> Promise<CBORWebToken> {
        do {
            let json = try coseSign1Message.toJSON()
            return jsonDecoder.decodePromise(json)
        } catch {
            return .init(error: error)
        }
    }

    private func checkExtendedKeyUsage(cborWebToken: CBORWebToken, trustCertificate: TrustCertificate) -> Promise<CBORWebToken> {
        HCert.checkExtendedKeyUsagePromise(
            certificate: cborWebToken,
            trustCertificate: trustCertificate
        )
        .map { cborWebToken }
    }

    private func certificateReissueRepositoryError(from error: Error) -> CertificateReissueRepositoryError {
        if let httpClientError = error as? HTTPClientError {
            switch httpClientError {
            case let .http(statusCode, data):
                guard let data = data,
                      let error = try? jsonDecoder.decode(CertificateReissueResponseError.self, from: data) else {
                    return statusCode.errorIfDataCouldNotBeDecoded()
                }
                return CertificateReissueRepositoryError(
                    error.error,
                    message: error.message
                )
            default:
                break
            }
        }
        return CertificateReissueRepositoryFallbackError()
    }
}

private extension Array where Element == String {
    var certificateRenewRequestBody: CertificateReissueRequestBody {
        .init(action: .renew, certificates: self)
    }
    
    var certificateExtendRequestBody: CertificateReissueRequestBody {
        .init(action: .extend, certificates: self)
    }
}

private extension Int {
    func errorIfDataCouldNotBeDecoded() -> CertificateReissueRepositoryError {
        switch self {
        case 429:
            return CertificateReissueRepositoryError("R429", message: nil)
        case 500:
            return CertificateReissueRepositoryError("R500", message: nil)
        default:
            return CertificateReissueRepositoryFallbackError()
        }
    }
}
