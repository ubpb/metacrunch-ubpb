require_relative "./generisches_element"

class Metacrunch::UBPB::Record::ElektronischeAdresse < Metacrunch::UBPB::Record::GenerischesElement
  SUBFIELDS = {
    a: { "Name des Host" => :W },
    b: { "IP-Adresse" => :NW },
    c: { "Art der Komprimierung" => :W },
    d: { "Zugriffspfad für eine Datei" => :W },
    f: { "elektronischer Name der Datei im Verzeichnis des Hosts" => :W },
    h: { "durchführende Stelle einer Anfrage" => :NW },
    i: { "Anweisung für die Ausführung einer Anfrage" => :W },
    j: { "Datenübertragungsrate" => :NW },
    k: { "Passwort" => :NW },
    l: { "Login" => :NW },
    m: { "Kontaktperson" => :W },
    n: { "Ort des Host" => :NW },
    o: { "Betriebssystem des Hosts" => :NW },
    p: { "Port" => :NW },
    q: { "elektronischer Dateiformattyp" => :NW },
    r: { "Einstellungen für die Dateiübertragung" => :NW },
    s: { "Größe der Datei" => :W },
    t: { "Unterstützte Terminal-Emulationen" => :W },
    u: { "URLs" => :W },
    v: { "Öffnungszeiten des Hosts für die gewählte Zugangsart" => :W },
    w: {
      "Identifikationsnummer" => :W,
      "Identifikationsnummer des verknüpften Datensatzes" => :W
    },
    x: { "Interne Bemerkungen" => :W },
    y: { "Link-Text" => :W },
    z: { "allgemeine Bemerkungen" => :W },
    A: { "Beziehung" => :NW },
    "2": { "Zugriffsmethode" => :NW },
    "3": { "Bezugswerk" => :NW }
  }

  def is_toc?
    get("allgemeine Bemerkungen").any?            { |element| element == "Inhaltsverzeichnis" } || # BVB
    get("Unterstützte Terminal-Emulationen").any? { |element| element  == "VIEW"              } || # Adam
    get("Bezugswerk") == "Inhaltsverzeichnis"                                                      # HBZ
  end

  private

  def default_value(options = {})
    include_options = [options[:include]].flatten(1).compact

    if include_options.include?("Inhaltsverzeichnisse")
      get("URLs")
    else
      get("URLs") unless is_toc?
    end
  end
end
