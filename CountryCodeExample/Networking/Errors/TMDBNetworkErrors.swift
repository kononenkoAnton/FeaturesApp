//
//  TMDBNetworkErrors.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/4/24.
//

enum TMDBNetworkErrors: Int {
    case success = 1
    case invalidService = 2
    case authenticationFailed = 3
    case invalidFormat = 4
    case invalidParameters = 5
    case invalidID = 6
    case invalidAPIKey = 7
    case duplicateEntry = 8
    case serviceOffline = 9
    case suspendedAPIKey = 10
    case internalError = 11
    case recordUpdated = 12
    case recordDeleted = 13
    case authenticationFailedAgain = 14
    case failed = 15
    case deviceDenied = 16
    case sessionDenied = 17
    case validationFailed = 18
    case invalidAcceptHeader = 19
    case invalidDateRange = 20
    case entryNotFound = 21
    case invalidPage = 22
    case invalidDate = 23
    case requestTimeout = 24
    case requestLimitExceeded = 25
    case usernamePasswordRequired = 26
    case tooManyAppendToResponseObjects = 27
    case invalidTimezone = 28
    case confirmationRequired = 29
    case invalidCredentials = 30
    case accountDisabled = 31
    case emailNotVerified = 32
    case invalidRequestToken = 33
    case resourceNotFound = 34
    case invalidToken = 35
    case tokenWritePermissionDenied = 36
    case sessionNotFound = 37
    case permissionDenied = 38
    case resourcePrivate = 39
    case nothingToUpdate = 40
    case tokenNotApproved = 41
    case methodNotSupported = 42
    case backendServerUnavailable = 43
    case invalidIDError = 44
    case userSuspended = 45
    case apiMaintenance = 46
    case invalidInput = 47

    var httpStatus: Int {
        switch self {
        case .success, .recordUpdated, .recordDeleted, .entryNotFound, .nothingToUpdate:
            return 200
        case .invalidService:
            return 501
        case .authenticationFailed, .invalidAPIKey, .suspendedAPIKey, .authenticationFailedAgain,
             .deviceDenied, .sessionDenied, .invalidCredentials, .accountDisabled, .emailNotVerified,
             .invalidRequestToken, .invalidToken, .tokenWritePermissionDenied, .permissionDenied,
             .resourcePrivate:
            return 401
        case .duplicateEntry, .userSuspended:
            return 403
        case .invalidFormat, .methodNotSupported:
            return 405
        case .invalidParameters, .invalidDateRange, .validationFailed, .tokenNotApproved, .tooManyAppendToResponseObjects,
             .invalidPage, .invalidDate, .invalidTimezone, .confirmationRequired, .usernamePasswordRequired:
            return 400
        case .serviceOffline, .apiMaintenance:
            return 503
        case .internalError, .failed:
            return 500
        case .resourceNotFound, .invalidID, .sessionNotFound:
            return 404
        case .requestTimeout:
            return 504
        case .backendServerUnavailable:
            return 502
        case .requestLimitExceeded:
            return 429
        case .invalidAcceptHeader:
            return 406
        case .invalidIDError:
            return 500
        case .invalidInput:
            return 400
        }
    }

    var localizedDescription: String {
        switch self {
        case .success:
            return "Success."
        case .invalidService:
            return "Invalid service: this service does not exist."
        case .authenticationFailed:
            return "Authentication failed: You do not have permissions to access the service."
        case .invalidFormat:
            return "Invalid format: This service doesn't exist in that format."
        case .invalidParameters:
            return "Invalid parameters: Your request parameters are incorrect."
        case .invalidID:
            return "Invalid id: The pre-requisite id is invalid or not found."
        case .invalidAPIKey:
            return "Invalid API key: You must be granted a valid key."
        case .duplicateEntry:
            return "Duplicate entry: The data you tried to submit already exists."
        case .serviceOffline:
            return "Service offline: This service is temporarily offline, try again later."
        case .suspendedAPIKey:
            return "Suspended API key: Access to your account has been suspended, contact TMDB."
        case .internalError:
            return "Internal error: Something went wrong, contact TMDB."
        case .recordUpdated:
            return "The item/record was updated successfully."
        case .recordDeleted:
            return "The item/record was deleted successfully."
        case .authenticationFailedAgain:
            return "Authentication failed."
        case .failed:
            return "Failed."
        case .deviceDenied:
            return "Device denied."
        case .sessionDenied:
            return "Session denied."
        case .validationFailed:
            return "Validation failed."
        case .invalidAcceptHeader:
            return "Invalid accept header."
        case .invalidDateRange:
            return "Invalid date range: Should be a range no longer than 14 days."
        case .entryNotFound:
            return "Entry not found: The item you are trying to edit cannot be found."
        case .invalidPage:
            return "Invalid page: Pages start at 1 and max at 500. They are expected to be an integer."
        case .invalidDate:
            return "Invalid date: Format needs to be YYYY-MM-DD."
        case .requestTimeout:
            return "Your request to the backend server timed out. Try again."
        case .requestLimitExceeded:
            return "Your request count is over the allowed limit."
        case .usernamePasswordRequired:
            return "You must provide a username and password."
        case .tooManyAppendToResponseObjects:
            return "Too many append to response objects: The maximum number of remote calls is 20."
        case .invalidTimezone:
            return "Invalid timezone: Please consult the documentation for a valid timezone."
        case .confirmationRequired:
            return "You must confirm this action: Please provide a confirm=true parameter."
        case .invalidCredentials:
            return "Invalid username and/or password: You did not provide a valid login."
        case .accountDisabled:
            return "Account disabled: Your account is no longer active. Contact TMDB if this is an error."
        case .emailNotVerified:
            return "Email not verified: Your email address has not been verified."
        case .invalidRequestToken:
            return "Invalid request token: The request token is either expired or invalid."
        case .resourceNotFound:
            return "The resource you requested could not be found."
        case .invalidToken:
            return "Invalid token."
        case .tokenWritePermissionDenied:
            return "This token hasn't been granted write permission by the user."
        case .sessionNotFound:
            return "The requested session could not be found."
        case .permissionDenied:
            return "You don't have permission to edit this resource."
        case .resourcePrivate:
            return "This resource is private."
        case .nothingToUpdate:
            return "Nothing to update."
        case .tokenNotApproved:
            return "This request token hasn't been approved by the user."
        case .methodNotSupported:
            return "This request method is not supported for this resource."
        case .backendServerUnavailable:
            return "Couldn't connect to the backend server."
        case .invalidIDError:
            return "The ID is invalid."
        case .userSuspended:
            return "This user has been suspended."
        case .apiMaintenance:
            return "The API is undergoing maintenance. Try again later."
        case .invalidInput:
            return "The input is not valid."
        }
    }
}
