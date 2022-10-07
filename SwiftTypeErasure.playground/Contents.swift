import Foundation

// Declaration
public protocol Permission: Equatable {}

// Examples of some Permissions we need
public enum UserPermissions: Permission {
    case download
    case share
}

public enum AdminPermissions: Permission {
    case create
    case delete
    case update
}

struct WrappedPermission {

    private let untypedPermission: Any

    init<T:Permission>(permission: T) {
        untypedPermission = permission
    }

    func isEqual<U: Permission>(to permission: U) -> Bool {
        guard let typedPermission = untypedPermission as? U else {
            return false
        }

        return typedPermission == permission
    }

}

protocol PermissionChecker {
    func has<T: Permission>(permission: T) -> Bool
}

class Profile: PermissionChecker {

    private var grantedPermission = [WrappedPermission(permission: UserPermissions.download)]

    func has<T: Permission>(permission: T) -> Bool  {
        return grantedPermission.contains { $0.isEqual(to: permission)
        }
    }
}

let profile = Profile()

print(profile.has(permission: AdminPermissions.delete))
print(profile.has(permission: UserPermissions.download))

