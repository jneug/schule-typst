#import "../../src/schule.typ": ab
#import ab: *

#show: arbeitsblatt(title: "Test")

Quelltext der Klasse `Die`:

```java
import java.util.Random;

/**
 * Ein normaler, sechsseitiger Würfel. Der Würfel kann geworfen werden und die
 * geworfene Zahl abgerufen werden. Jeder Würfel hat einen Namen, mit dem er
 * identifiziert werden kann.
 */
public class Die {

    /**
     * Der Name des Würfels.
     */
    private final String name;

    /**
     * Der Zufallsgenerator dieses Würfels.
     */
    private final Random rand;

    /**
     * Der zuletzt geworfene Wert.
     */
    private int value;

    /**
     * Erstellt einen Würfel mit einem Namen zur Identifikation.
     *
     * @param pName
     */
    public Die( String pName ) {
        name = pName;
        rand = new Random();
        roll();
    }

    /**
     * Wirft den Würfel. Die geworfene Augenzahl kann dann mit
     * {@link #getValue()} abgerufen werden.
     */
    public void roll() {
        value = rand.nextInt(6) + 1;
    }

    /**
     * Gibt die zuletzt geworfene Augenzahl (die "oben" liegt) zurück.
     *
     * @return Die Augenzahl.
     */
    public int getValue() {
        return value;
    }

    /**
     * Gibt den Namen des Würfels zurück.
     *
     * @return Der Name des Würfels.
     */
    public String getName() {
        return name;
    }

    /**
     * Erstellt einen String, der das Objekt repräsentiert. Zum Beispiel für dei
     * Ausgabe auf der Konsole.
     *
     * @return DAs Objekt als String.
     */
    @Override
    public String toString() {
        return name + "<" + value + ">";
    }

}
```
