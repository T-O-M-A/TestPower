/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interface;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Image;
import java.awt.Point;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.imageio.ImageIO;
import javax.swing.BorderFactory;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

/**
 *
 * @author Lair Thomas, Bonjean Grégoire & Crépin Baptiste
 */
public class FenetreCas extends Fenetre {

    String cas;

    public FenetreCas(String title,
            Dimension dim,
            Fenetre prec,
            Fenetre suiv,
            Fenetre home,
            Point location,
            final String cas) {
        super(title, dim, prec, suiv, home, location);
        fen = this;
        this.cas = cas;

        Image img;
        switch (cas) {
            case "Simple":
                try {
                    img = ImageIO.read(getClass().getResource("loi_n.png"));
                } catch (IOException e) {
                    img = null;
                }
                break;
            case "Régression":
                try {
                    img = ImageIO.read(getClass().getResource("linear_r.png"));
                } catch (IOException e) {
                    img = null;
                }
                break;
            default:
                try {
                    img = ImageIO.read(getClass().getResource("donnees.gif"));
                } catch (IOException e) {
                    img = null;
                }
                break;
        }

        JPanel panCas = new ImagePane(img, 5, 15);
        panCas.setBackground(Color.white);
        panCas.setLayout(new BorderLayout());
        panCas.setPreferredSize(new Dimension((int) (dim.width * 0.95), (int) ((dim.height - 100) * 0.33)));
        panCas.setBorder(BorderFactory.createTitledBorder("Cas : " + cas));

        JPanel panDescr = new JPanel();
        panDescr.setBackground(Color.gray);
        panDescr.setPreferredSize(new Dimension((int) (dim.width * 0.6675), (int) ((dim.height - 100) * 0.5)));
        panDescr.setBorder(BorderFactory.createTitledBorder("<html><font color = white >Description</font></html>"));
        panCas.add(panDescr, BorderLayout.EAST);

        this.getContentPane().add(panCas);

        JPanel panChoix = new JPanel();
        panChoix.setBackground(Color.white);
        panChoix.setLayout(new BorderLayout());
        panChoix.setPreferredSize(new Dimension((int) (dim.width * 0.95), (int) ((dim.height - 100) * 0.6)));
        panChoix.setBorder(BorderFactory.createTitledBorder("Choisissez un sous-type de cas"));

        switch (cas) {
            case "Simple":
                JPanel panStudent = new JPanel();
                panStudent.setBackground(Color.lightGray);
                panStudent.setPreferredSize(new Dimension((int) (dim.width * 0.467), (int) ((dim.height - 100) * 0.3)));
                panStudent.setBorder(BorderFactory.createTitledBorder("t-Test de Student"));

                JPanel panUn = new JPanel();
                panUn.setBackground(Color.white);
                panUn.setPreferredSize(new Dimension((int) (dim.width * 0.458), (int) ((dim.height - 100) * 0.162)));
                panUn.setBorder(BorderFactory.createTitledBorder("Un Échantillon"));
                BoutonSousCas boutonUn = new BoutonSousCas(this, "Un Échantillon");
                boutonUn.setPreferredSize(new Dimension((int) (dim.width * 0.44), (int) ((dim.height - 100) * 0.11)));
                panUn.add(boutonUn);
                panStudent.add(panUn);

                JPanel panApp = new JPanel();
                panApp.setBackground(Color.white);
                panApp.setPreferredSize(new Dimension((int) (dim.width * 0.458), (int) ((dim.height - 100) * 0.162)));
                panApp.setBorder(BorderFactory.createTitledBorder("Deux Échantillons Appariés"));
                BoutonSousCas boutonApp = new BoutonSousCas(this, "Deux Échantillons Appariés");
                boutonApp.setPreferredSize(new Dimension((int) (dim.width * 0.44), (int) ((dim.height - 100) * 0.11)));
                panApp.add(boutonApp);
                panStudent.add(panApp);

                JPanel panInd = new JPanel();
                panInd.setBackground(Color.white);
                panInd.setPreferredSize(new Dimension((int) (dim.width * 0.458), (int) ((dim.height - 100) * 0.162)));
                panInd.setBorder(BorderFactory.createTitledBorder("Deux Échantillons Indépendants"));
                BoutonSousCas boutonInd = new BoutonSousCas(this, "Deux Échantillons Indépendants");
                boutonInd.setPreferredSize(new Dimension((int) (dim.width * 0.44), (int) ((dim.height - 100) * 0.11)));
                panInd.add(boutonInd);
                panStudent.add(panInd);

                panChoix.add(panStudent, BorderLayout.WEST);

                JPanel panAutre = new JPanel();
                panAutre.setBackground(Color.white);
                panAutre.setLayout(new BorderLayout());
                panAutre.setPreferredSize(new Dimension((int) (dim.width * 0.467), (int) ((dim.height - 100) * 0.3)));

                JPanel panCorr = new JPanel();
                panCorr.setBackground(Color.lightGray);
                panCorr.setPreferredSize(new Dimension((int) (dim.width * 0.467), (int) ((dim.height - 100) * 0.27)));
                panCorr.setBorder(BorderFactory.createTitledBorder("Test de Corrélation de Pearson"));

                JPanel panIntCorr = new JPanel();
                panIntCorr.setBackground(Color.white);
                panIntCorr.setPreferredSize(new Dimension((int) (dim.width * 0.45), (int) ((dim.height - 100) * 0.215)));
                BoutonSousCas boutonCorr = new BoutonSousCas(this, "Corrélation de Pearson");
                boutonCorr.setPreferredSize(new Dimension((int) (dim.width * 0.44), (int) ((dim.height - 100) * 0.19)));
                panIntCorr.add(boutonCorr);
                panCorr.add(panIntCorr);

                panAutre.add(panCorr, BorderLayout.NORTH);

                JPanel panAnova = new JPanel();
                panAnova.setBackground(Color.lightGray);
                panAnova.setPreferredSize(new Dimension((int) (dim.width * 0.467), (int) ((dim.height - 100) * 0.27)));
                panAnova.setBorder(BorderFactory.createTitledBorder("Test d'ANOVA"));

                JPanel panIntAnova = new JPanel();
                panIntAnova.setBackground(Color.white);
                panIntAnova.setPreferredSize(new Dimension((int) (dim.width * 0.45), (int) ((dim.height - 100) * 0.215)));
                BoutonSousCas boutonAnova = new BoutonSousCas(this, "ANOVA");
                boutonAnova.setPreferredSize(new Dimension((int) (dim.width * 0.44), (int) ((dim.height - 100) * 0.19)));
                panIntAnova.add(boutonAnova);
                panAnova.add(panIntAnova);

                panAutre.add(panAnova, BorderLayout.SOUTH);

                panChoix.add(panAutre, BorderLayout.EAST);
                break;

            case "Régression":
                JPanel panUnique = new JPanel();
                panUnique.setBackground(Color.lightGray);
                panUnique.setLayout(new BorderLayout());
                panUnique.setPreferredSize(new Dimension((int) (dim.width * 0.467), (int) ((dim.height - 100) * 0.3)));

                try {
                    img = ImageIO.read(getClass().getResource("simple_formula.png"));
                } catch (IOException e) {
                    img = null;
                }

                JPanel panSimple = new ImagePane(img, 5, 22);
                panSimple.setBackground(Color.lightGray);
                panSimple.setLayout(new BorderLayout());
                panSimple.setPreferredSize(new Dimension((int) (dim.width * 0.467), (int) ((dim.height - 100) * 0.27)));
                panSimple.setBorder(BorderFactory.createTitledBorder("Régression Simple"));

                JPanel panIntSimple = new JPanel();
                panIntSimple.setBackground(Color.lightGray);
                panIntSimple.setPreferredSize(new Dimension((int) (dim.width * 0.243), (int) ((dim.height - 100) * 0.215)));
                BoutonSousCas boutonSimple = new BoutonSousCas(this, "Régression Simple");
                boutonSimple.setPreferredSize(new Dimension((int) (dim.width * 0.243), (int) ((dim.height - 100) * 0.215)));
                panIntSimple.add(boutonSimple);
                panSimple.add(panIntSimple, BorderLayout.EAST);

                panUnique.add(panSimple, BorderLayout.NORTH);

                JPanel panVideUnique = new JPanel();
                panVideUnique.setBackground(Color.white);
                panVideUnique.setPreferredSize(new Dimension((int) (dim.width * 0.467), (int) ((dim.height - 100) * 0.04)));

                panUnique.add(panVideUnique, BorderLayout.CENTER);

                try {
                    img = ImageIO.read(getClass().getResource("mixed_effect_formula.png"));
                } catch (IOException e) {
                    img = null;
                }

                JPanel panMixte = new ImagePane(img, 5, 22);
                panMixte.setBackground(Color.lightGray);
                panMixte.setLayout(new BorderLayout());
                panMixte.setPreferredSize(new Dimension((int) (dim.width * 0.467), (int) ((dim.height - 100) * 0.27)));
                panMixte.setBorder(BorderFactory.createTitledBorder("Régression avec Effets Mixtes"));

                JPanel panIntMixte = new JPanel();
                panIntMixte.setBackground(Color.lightGray);
                panIntMixte.setPreferredSize(new Dimension((int) (dim.width * 0.243), (int) ((dim.height - 100) * 0.215)));
                BoutonSousCas boutonMixte = new BoutonSousCas(this, "Régression avec Effets Mixtes");
                boutonMixte.setPreferredSize(new Dimension((int) (dim.width * 0.243), (int) ((dim.height - 100) * 0.215)));
                panIntMixte.add(boutonMixte);
                panMixte.add(panIntMixte, BorderLayout.EAST);

                panUnique.add(panMixte, BorderLayout.SOUTH);

                panChoix.add(panUnique, BorderLayout.WEST);

                JPanel panDouble = new JPanel();
                panDouble.setBackground(Color.lightGray);
                panDouble.setLayout(new BorderLayout());
                panDouble.setPreferredSize(new Dimension((int) (dim.width * 0.467), (int) ((dim.height - 100) * 0.3)));

                try {
                    img = ImageIO.read(getClass().getResource("multiple_formula.png"));
                } catch (IOException e) {
                    img = null;
                }

                JPanel panMultiple = new ImagePane(img, 5, 22);
                panMultiple.setBackground(Color.lightGray);
                panMultiple.setLayout(new BorderLayout());
                panMultiple.setPreferredSize(new Dimension((int) (dim.width * 0.467), (int) ((dim.height - 100) * 0.27)));
                panMultiple.setBorder(BorderFactory.createTitledBorder("Régression Multiple"));

                JPanel panIntMultiple = new JPanel();
                panIntMultiple.setBackground(Color.lightGray);
                panIntMultiple.setPreferredSize(new Dimension((int) (dim.width * 0.243), (int) ((dim.height - 100) * 0.215)));
                BoutonSousCas boutonMultiple = new BoutonSousCas(this, "Régression Multiple");
                boutonMultiple.setPreferredSize(new Dimension((int) (dim.width * 0.243), (int) ((dim.height - 100) * 0.215)));
                panIntMultiple.add(boutonMultiple);
                panMultiple.add(panIntMultiple, BorderLayout.EAST);

                panDouble.add(panMultiple, BorderLayout.NORTH);

                JPanel panVideMultiple = new JPanel();
                panVideMultiple.setBackground(Color.white);
                panVideMultiple.setPreferredSize(new Dimension((int) (dim.width * 0.467), (int) ((dim.height - 100) * 0.04)));

                panDouble.add(panVideMultiple, BorderLayout.CENTER);

                try {
                    img = ImageIO.read(getClass().getResource("interaction_formula.png"));
                } catch (IOException e) {
                    img = null;
                }

                JPanel panInter = new ImagePane(img, 5, 22);
                panInter.setBackground(Color.lightGray);
                panInter.setLayout(new BorderLayout());
                panInter.setPreferredSize(new Dimension((int) (dim.width * 0.467), (int) ((dim.height - 100) * 0.27)));
                panInter.setBorder(BorderFactory.createTitledBorder("Régression Multiple avec Intéraction"));

                JPanel panIntInter = new JPanel();
                panIntInter.setBackground(Color.lightGray);
                panIntInter.setPreferredSize(new Dimension((int) (dim.width * 0.243), (int) ((dim.height - 100) * 0.215)));
                BoutonSousCas boutonInter = new BoutonSousCas(this, "Régression Multiple avec Intéraction");
                boutonInter.setPreferredSize(new Dimension((int) (dim.width * 0.243), (int) ((dim.height - 100) * 0.215)));
                panIntInter.add(boutonInter);
                panInter.add(panIntInter, BorderLayout.EAST);

                panDouble.add(panInter, BorderLayout.SOUTH);

                panChoix.add(panDouble, BorderLayout.EAST);
                break;
            default:

                break;
        }

        this.getContentPane().add(panChoix);

        this.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                if (JOptionPane.showConfirmDialog(fen,
                        "Voulez-vous fermer l'application ?", "Fermeture ?",
                        JOptionPane.YES_NO_OPTION,
                        JOptionPane.QUESTION_MESSAGE) == JOptionPane.YES_OPTION) {
                    System.exit(0);
                } else {
                    FenetreCas new_fen = new FenetreCas("Fenetre Principale",
                            new Dimension(fen.getWidth(), fen.getHeight()), null, null, null, fen.getLocation(), cas);
                }
            }
        }
        );
    }
}
