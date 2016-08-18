import Contacts
import ContactsUI

extension CNContactViewController {

  // MARK: Initialization

  convenience init(vcardData: NSData) {
    do {
      let contact : CNContact = try CNContactVCardSerialization.contactsWithData(vcardData).first as! CNContact

      self.init(forUnknownContact: contact)

    } catch {
      fatalError("Could not convert vcardData into CNContact.")
    }
  }

}
