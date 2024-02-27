import FungibleToken from 0x05


pub fun main(user: Address): {UInt64: UFix64} {


    let authAccount = getAuthAccount(user)
    

    var vaults: {UInt64: UFix64} = {}


    authAccount.forEachStored(fun(path: StoragePath, type: Type): Bool {

        if type.isSubtype(of: Type<@FungibleToken.Vault>()) {

            let vaultRef = authAccount.borrow<&FungibleToken.Vault>(from: path)!

            vaults[vaultRef.uuid] = vaultRef.balance
        }
        return true
    })


    return vaults
}