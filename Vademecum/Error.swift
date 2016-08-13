struct Error {
    static let HTTPNotFoundError = Error(title: "Inhalt nicht gefunden", message: "Hier ist nichts ...")
    static let NetworkError = Error(title: "Verbindungsproblem :)", message: "Diese Anwendung benötigt einen Internetzugang.")
    static let UnknownError = Error(title: "Unbekannter Fehler", message: "Das ist dumm gelaufen.")

    let title: String
    let message: String

    init(title: String, message: String) {
        self.title = title
        self.message = message
    }

    init(HTTPStatusCode: Int) {
        self.title = "Server Error"
        self.message = "The server returned an HTTP \(HTTPStatusCode) response."
    }
}