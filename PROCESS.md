#Process Book

###Day 1 Maandag week 1
- Proposal gemaakt
- Met julian overlegd waar nu de prioriteiten en eventuele problemen liggen
- Eerst kijken wat er mogelijk is met de map api, of het uberhaupt mogelijk is om een radius te creeren met trigger boundaries. Als dat niet zo is, misschien andere weg in gaan.

###Day 2 Dinsdag

- Tutorials gedaan over MapKit.
- Op een goudmijn gestapt met een tutorial op Ray Wenderlich over location based notifications, is gelukt maar wel ingewikkelde code. Wel heeft het een bug dat hij verkeerde triggers geeft. (net iets te ver erbuiten etc) maar in ieder geval legit genoeg.
- foto()

###Day 3 Woensdag

- USE: [CLLocationManager, CLRegion, CLCircularRegion, startMonitoringForRegion, CLLocationManagerDelegate, didStartMonitoringForRegion, monitoringDidFailForRegion, didEnterRegion, didExitRegion, startUpdatingLocation, containsCoordinate]
- library gevonden voor makkelijk longtitude en latitude van locatie ophalen. (Cocoapod geinstalleerd voor makkelijk libraries gebruiken in Xcode)
- Nearby Xcode project begonnen, MapKit verkend gekregen en locatie kunnen ophalen

###Day 4 Donderdag 

- Data model gemaakt voor het opslaan van de venues (naam, image etc)
- Data model gekoppeld aan user interface (table view) geprobeerd om een collection view te maken in de table view (om een grid te krijgen met plaatjes) dit was maybe toch wat te ingewikkeld maar wellicht leuk voor later.

###Day 5 Vrijdag
- gekeken naar zoomen op locatie (gelukt), zoeken en neerzetten van annotaties (forward geocoding) op de map (in progress). 
- Design Document gemaakt

###Day 6 Maandag week 2
- Forward geocoding is gelukt, MKLocalsearch neemt een string en vind de dichtstbijzijnde hits rond de gebruikers locatie. Deze worden vervolgens met annotaties op de map geplot.

###Day 7 Dinsdag 

- Cellen van VenueTableViewCell interactble gemaakt, UIAlertController aan de plus-button gehangen. 
- Honderd jaar over gedaan om de data die in de custom cellen staan door te geven aan NSUSerDefaults via een actie button. De data word nu ogehaald in de TableView functie en moet doorgegeven worden aan de IBAction van de plusbutton. Dit kan niet omdat de variabele waarin het word opgeslagen niet de functie uit kan. geprobeerd global te maken, maar dan gaat hij zeuren over types. Kan niet achterhalen wat voor type het is. > julian morgen vragen.

###Day 8 Woensdag
- VenueTableView en FavoriteTableView werkt nu goed met opslaan en verwijderen van favorieten. (slide to delete) NSUserdefaults update mee.
- Nest step: de favorieten op de map laten plotten. 

###Day 9 Donderdag
- Search uitvoeren op de favorieten en op map geplot
- MakeRegion functie gemaakt om MKmapitems om te zetten naar CLregions
- Startmonitor aangemaakt om de CLregions te monitoren

###Day 10 Vrijdag
- debuggen en testen

###Zondag 
- notificaties gemaakt en fieldtesten 
- werkt, maar alleen met unieke identifiers
- en de accuratie is bagger

###Day 11 Maandag
- identifiers verbouwd naar straat en huisnummer
- gekeken naar de accuracy, wellicht goede code gevonden

###Day 12 Dinsdag
- kleine bugs fixen

###Day 13 Woensdag
- Favorieten toevoegen en verwijderen
- Updaten van regions als er iets is veranderd

###Day 14 Donderdag 
- Refresh ingebouwd als er 1km word verplaats word er gezocht en gemonitord naar nieuwe plaatsen
- Annotaties custom gemaakt, kan op geklikt worden

###Day 15 Vrijdag 

- presentatie/bier drinken

###Day 16 Monday 

- fixed bug MKLocalsearch and zooming in
- Annotation button triggered apple Maps voor location
- App icon gemaakt

###Day 17 Tuesday

- code verplaatsen naar goede file
- natuurlijk alles kapot gemaakt

###Day 18 Woensdag

- code review en comments geschreven

###Day 19 Donderdag

- layout mooi gemaakt
- icoontjes naar hogere resolutie
- searchbar weggehaald
- launch screen gemaakt
- unknown location apple maps bug gefixed


#LINKS

http://stackoverflow.com/questions/30063986/swift-directions-to-selected-annotation-from-current-location-in-maps














