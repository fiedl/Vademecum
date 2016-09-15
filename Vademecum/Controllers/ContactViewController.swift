import Contacts
import ContactsUI

extension CNContactViewController {

  // MARK: Initialization

  convenience init(vcardData: Data) {
    do {
      let contact : CNContact = try CNContactVCardSerialization.contacts(with: vcardData).first!

      self.init(forUnknownContact: contact)

    } catch {
      fatalError("Could not convert vcardData into CNContact.")
    }
  }

}
