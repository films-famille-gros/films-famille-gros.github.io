Dans les coulisses
==================

Origine du projet
-----------------

À l'été 2022, je suis monté pour la première fois au sommet de la `Croix des
Têtes <https://fr.wikipedia.org/wiki/Croix_des_Têtes>`_, sommet iconique de la
Maurienne et situé au-dessus de la maison de Saint-Martin-de-la-Porte.

Ce même été, j'en ai parlé à ma mère, Renée. J'ai alors appris que la croix
située à son sommet avait été placée par un groupe dont papi Gros a fait
partie, et qu'un film existe!

J'avais entendu parlé des films 8mm de la famille, mais sans savoir où ils
étaient, ou bien s'ils avaient été numérisés. Après avoir cherché des
informations sur le sujet, j'ai vu qu'il était assez aisé de les scanner
soi-même. Me voici donc parti dans ce projet!

J'ai contacté d'abord Gérard pour savoir s'il possédait toujours les films et si
ceux-là avaient été numérisés. Finalement, c'est Jean-Claude qui les possédait.
Il me les a envoyé.

Scanner
-------

J'ai utilisé le modèle Kodak Reelz, dont voici une `démonstration
<https://www.youtube.com/watch?v=hWNmRUgmHTI>`_, revendu après son utilisation.

Pour faire simple, c'est un appareil qui scanne image par image toute la bobine,
et produit un fichier vidéo en sortie. Compter environ 30min pour une bobine 15m
(~3 min de film). Il n'est pas capable de lire le son sur les bobines, mais les
films de la famille étant muets, ce n'est pas un problème.

Il existe des appareils professionnels (> 10'000 euros) qui permettent d'avoir
une qualité bien supérieure, mais pour un projet passe-temps comme celui-là, la
qualité est suffisante.

Nettoyage vidéo
---------------

En sortie du scanner, les vidéos ont quelques défauts.

Comme il y a 42 films à traiter, je ne souhaitais pas le faire manuellement J'ai
donc cherché un moyen de les traiter automatiquement, en utilisant `ffmpeg
<https://ffmpeg.org/>`_ et en automatisant cela à l'aide de ce `script
<https://github.com/films-famille-gros/films-famille-gros.github.io/blob/main/transform_video.sh>`_.

Par chance, étant informaticien, et ayant travaillé sur la compression vidéo
dans une de mes expériences, j'avais un bon bagage pour me lancer dedans.

Très concrètement, voici deux exemples "avant/après" pour montrer le résultat:

.. video:: https://raw.githubusercontent.com/films-famille-gros/static/main/videos/compare_1.mp4
   :height: 150

.. video:: https://raw.githubusercontent.com/films-famille-gros/static/main/videos/compare_4.mp4
   :height: 150

Dans l'ordre, les choses suivantes sont faites:

- fix_framerate: corriger la vitesse de la vidéo (le scanner sort du 20
  images/secondes, alors que le 8mm est du 16 images/secondes).
- denoise: enlever le "bruit" de la vidéo, c'est à dire les fourmillements qu'on
  peut observer. Cela se fait au prix d'un léger flou (réglable), que j'ai
  choisi au mieux.
- deflicker: enlever les différences de luminosité entre image, qui provoquait
  un effet de scintillement.
- stabilize: stabiliser l'image. Probablement l'un des nettoyages les plus
  visibles, il supprime tout tremblement (que ce soit dû au scanner, ou bien à
  la caméra qui a filmé les images).
- interpolate: Comme les films originaux sont en 16 images/secondes, c'est bien
  peu pour l'oeil humain. (youtube et la TV sont en 30 i/s, le cinéma en 24 i/s).
  Ici ffmpeg fait de la "magie", et détecte les changements entre deux images,
  pour créer de nouvelles images, complètement artificielles. Cela se voit
  parfois, sur des effets de "fantômes" le long des mouvement. Mais dans
  l'ensemble, c'est vraiment remarquable.
- encode: Les fichiers originaux pèsent environ 200Mo pour 3 min. Là, on réduit
  à 100Mo, car c'est une limite pour l'hébergement des fichiers que j'ai choisi.
  À la base j'avais choisi le codec HEVC (h265), mais malheureusment, aucun
  navigateur web ne peut le lire. J'ai aussi essayé AV1 (le nouveau standard),
  mais les temps d'encodage sont délirants. Du coup, j'ai laissé du h264, qui
  fait bien son travail.

Le nettoyage des 42 vidéos a pris environ 1 semaine sur ma machine (Intel Core
i7-10700K). La beauté de l'automatisation fait que je pourrai refaire cela dans
le futur sans effort si un meilleur outil est disponible.

Avec les progrès en intelligence artificielle ces dernières années (comme
`Real-ESRGAN <https://github.com/xinntao/Real-ESRGAN>`_), il y aura à coup sûr
des belles nouveautés dans 10 ans!

Site internet
-------------

J'ai utilisé la solution `Sphinx <https://www.sphinx-doc.org/en/master/>`_, qui
est un système de génération de documentation assez populaire chez les
programmeurs.

Couplé à `Ablog <https://ablog.readthedocs.io/en/latest/>`_, il est facile de
créer un blog, comme ce site. Chaque vidéo possède ainsi sa propre `page
<https://github.com/films-famille-gros/films-famille-gros.github.io/tree/main/posts>`_,
et l'outil s'occupe de tout générer automatiquement, sans taper une seule ligne
de HTML/CSS.

Le dépôt du site est accessible `ici <https://github.com/films-famille-gros/films-famille-gros.github.io>`_.

Hébergement
-----------

Le site est hébergé sur `Github pages <https://pages.github.com/>`_, que
j'utilisais déjà pour mon `site personnel <https://second-reality.github.io/>`_
ainsi que mes `photos <https://pimpmypicture.github.io/>`_.

C'est gratuit, valable à vie, et il n'y a rien à maintenir. Cependant, il existe
une limite en taille (1Go max) et en traffic (100Go/mois).

Ce site est très léger, et ce sont les vidéos qui le composent qui posent
problème. Ainsi, pour contourner cette limite, celles-ci sont situées dans un
`deuxième dépôt <https://github.com/films-famille-gros/static>`_. Dans ce cas,
il n'y a pas de limite de traffic, et la taille est de 10Go max. La seule limite
est sur la taille de fichier: 100Mo maximum. C'est pour cela que les vidéos
visent cette taille (voir "encode" au dessus).

Conclusion
----------

Il était appréciable de mettre à profit mes connaissances en informatique,
vidéo, et web, pour pouvoir "immortaliser" ces vidéos. J'espère que vous en
profiterez, et transmettrez cela!

Pierrick
