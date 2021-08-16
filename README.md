# Model explainability en fairness

## Packages

Er wordt gebruik gemaakt van de volgende packages:

- [DALEX](https://modeloriented.github.io/DALEX/)  

- [DALEXtra](https://modeloriented.github.io/DALEXtra/)

- [fairmodels](https://modeloriented.github.io/fairmodels/)

Simpel te installeren met behulp van dit command:

        install.packages(c("DALEX", "DALEXtra", "fairmodels"))

## Functies
Het voornaamste doel van deze repo is het uitvoeren van de scripts. Toch is er ook een mogelijkheid om de functies naar eigen wens te gebruiken. De volgende functies zijn aanwezig.

### explainability

#### Instance level

#### Dataset level

### Fairness

## Gebruik
Voor dat het gebruik van de explainability en fairness scripts mogelijk is moeten er eerst twee functies gecalled worden.

    make_vars(<model>, <training_data>, <target_variable>, <label>, <PDP_variable>, <seed>)

    make_fairness_vars(<explainer>, <protected>, <privileged>, <cutoff>)

Deze functies zorgen ervoor dat de data onder de juiste variabelen komen te staan zodat het script zonder errors kan draaien.

