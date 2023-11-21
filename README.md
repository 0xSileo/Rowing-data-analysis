# Rowing data analysis

## Français
### Notes

J'emloierai ici le mot "rameur" pour désigner l'individu, et non l'appareil.

### Données du rameur

Lorsque l'on rame sur [ergomètre](https://fr.wikipedia.org/wiki/Ergom%C3%A8tre), plusieurs données sont récoltées. L'analyse de celles-ci sur plusieurs entraînements permet de voir l'évolution du rameur, et, dans une certaine mesure, de concevoir un programme d'entraînement personnalisé. Les données les plus communément relevées et analysées sont le <b>temps pour 500 mètres</b> (ou <i>pace</i>) et le nombre de coups par minute (<b>SPM</b> pour <i>strokes per minute</i>). Le premier est influencé par la force que le rameur applique lorsqu'il tire la chaîne, ainsi que la fréquence à laquelle il le fait (donnée par le SPM). 


### La loi de Paul
Il est intuitif de se dire que pour des distances courtes, le rameur pourra tenir un rythme plus élevé que pour des distances plus longues, et donc aura un temps moyen par 500m plus bas. La [loi de Paul](https://paulergs.weebly.com/blog/a-quick-explainer-on-pauls-law) est une relation déterminée expérimentalement qui dit que si l'on double la distance parcourue, le rythme augmentera de 5 secondes. Plus précisément, on a 

$$
p_2 = p_1 + 5\log_2\frac{d_2}{d_1} 
$$

où $p_1$ est le rythme que le rameur a tenu sur la distance $d_1$. Si l'on veut tenter de prédire $p_2$, le rythme que le rameur tiendra sur une distance $d_2$, nous pouvons appliquer la formule. Il est possible d'effectuer une régression sur les données si l'on connait les temps pour 500m $(p_1,p_2,p_3\dots p_n)$ d'un rameur sur différentes distances $(d_1,d_2,d_3\dots d_n)$.  La loi de Paul prenant généralement le rythme pour 2000m comme repère, il est possible de connaître la valeur de $p_{2000m}$ qui permettra de tracer la courbe de Paul en appliquant la méthode des moindres carrés. 

```r
# Linéarisation des données (par rapport à 2000 m)
dist_transformed <- 5 * log2(distances/2000)

# Régression linéaire
model <- lm(pace ~ dist_transformed)
```

Le modèle nous donne donc l'expression de la courbe de Paul, ajustée aux données du rameur. Cela nous permet de prévoir le rythme à tenir pour faire une distance choisie.

```r
# Prédictions pour 5, 10 et 21 km. 
predict(model, newdata = data.frame(dist_transformed=c(5000,10000,21000)))
```

### Graphique pace - SPM

Afin de perfectionner un entraînement, il est utile de visualiser les performances déjà réalisées, en créant un graphique qui met le temps pour 500m en relation avec le SPM moyen.
