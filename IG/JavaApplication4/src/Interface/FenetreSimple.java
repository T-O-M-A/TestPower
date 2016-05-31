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
public class FenetreSimple extends Fenetre {

    String cas;

    public FenetreSimple(String title,
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
            case "Un Échantillon":
                try {
                    img = ImageIO.read(getClass().getResource("one_sample.gif"));
                } catch (IOException e) {
                    img = null;
                }
                break;
            case "Deux Échantillons Appariés":
                try {
                    img = ImageIO.read(getClass().getResource("paired.gif"));
                } catch (IOException e) {
                    img = null;
                }
                break;
            case "Corrélation de Pearson":
                try {
                    img = ImageIO.read(getClass().getResource("pearson.png"));
                } catch (IOException e) {
                    img = null;
                }
                break;
            case "ANOVA":
                try {
                    img = ImageIO.read(getClass().getResource("fisher.png"));
                } catch (IOException e) {
                    img = null;
                }
                break;
            case "Régression Simple":
                try {
                    img = ImageIO.read(getClass().getResource("simple_regression.png"));
                } catch (IOException e) {
                    img = null;
                }
                break;
            case "Régression avec Effets Mixtes":
                try {
                    img = ImageIO.read(getClass().getResource("mixed_effects.png"));
                } catch (IOException e) {
                    img = null;
                }
                break;
            case "Régression Multiple":
                try {
                    img = ImageIO.read(getClass().getResource("multiple_regression.jpg"));
                } catch (IOException e) {
                    img = null;
                }
                break;
            case "Régression Multiple avec Intéraction":
                try {
                    img = ImageIO.read(getClass().getResource("interaction.png"));
                } catch (IOException e) {
                    img = null;
                }
                break;
            default:
                try {
                    img = ImageIO.read(getClass().getResource("independant.gif"));
                } catch (IOException e) {
                    img = null;
                }
                break;
        }

        JPanel panCas = new ImagePane(img, 5, 15);
        panCas.setBackground(Color.white);
        panCas.setLayout(new BorderLayout());
        panCas.setPreferredSize(new Dimension((int) (dim.width * 0.95), (int) ((dim.height - 100) * 0.279)));
        panCas.setBorder(BorderFactory.createTitledBorder("Sous-cas : " + cas));

        JPanel panDescr = new JPanel();
        panDescr.setBackground(Color.gray);
        panDescr.setPreferredSize(new Dimension((int) (dim.width * 0.6675), (int) ((dim.height - 100) * 0.5)));
        panDescr.setBorder(BorderFactory.createTitledBorder("<html><font color = white >Description</font></html>"));
        panCas.add(panDescr, BorderLayout.EAST);

        this.getContentPane().add(panCas);

        JPanel panChoix = new JPanel();
        panChoix.setBackground(Color.white);
        panChoix.setLayout(new BorderLayout());
        panChoix.setPreferredSize(new Dimension((int) (dim.width * 0.95), (int) ((dim.height - 100) * 0.7)));
        panChoix.setBorder(BorderFactory.createTitledBorder("Renseignez l'un des groupes de champs"));

        JPanel panStudent = new JPanel();
        panStudent.setBackground(Color.lightGray);
        panStudent.setPreferredSize(new Dimension((int) (dim.width * 0.467), (int) ((dim.height - 100) * 0.3)));
        switch (cas) {
            case "Un Échantillon":
                panStudent.setBorder(BorderFactory.createTitledBorder("t-Test de Student"));
                break;
            case "Deux Échantillons Appariés":
                panStudent.setBorder(BorderFactory.createTitledBorder("t-Test de Student"));
                break;
            case "Deux Échantillons Indépendants":
                panStudent.setBorder(BorderFactory.createTitledBorder("t-Test de Student"));
                break;
            case "Corrélation de Pearson":
                panStudent.setBorder(BorderFactory.createTitledBorder("Test de Corrélation de Pearson"));
                break;
            case "ANOVA":
                panStudent.setBorder(BorderFactory.createTitledBorder("Test d'ANOVA"));
                break;
            default:
                panStudent.setBorder(BorderFactory.createTitledBorder(""));
                break;
        }

        JPanel panVerifSimple = new JPanel();
        panVerifSimple.setBackground(Color.white);
        panVerifSimple.setPreferredSize(new Dimension((int) (dim.width * 0.458), (int) ((dim.height - 100) * 0.305)));
        switch (cas) {
            case "Un Échantillon":
            case "Deux Échantillons Appariés":
            case "Deux Échantillons Indépendants":
            case "Corrélation de Pearson":
            case "ANOVA":
                panVerifSimple.setBorder(BorderFactory.createTitledBorder("Vérification du Test"));
                break;
            default:
                panVerifSimple.setBorder(BorderFactory.createTitledBorder("Vérification de la Régression"));
                break;
        }

        JPanel panPuissanceSimple = new JPanel();
        panPuissanceSimple.setBackground(Color.white);
        panPuissanceSimple.setPreferredSize(new Dimension((int) (dim.width * 0.458), (int) ((dim.height - 100) * 0.305)));
        panPuissanceSimple.setBorder(BorderFactory.createTitledBorder("Calcul de Puissance"));

        switch (cas) {
            case "Un Échantillon":

                break;

            case "Deux Échantillons Appariés":

                break;
            case "Corrélation de Pearson":

                break;
            case "ANOVA":

                break;
            default:

                break;
        }

        panStudent.add(panVerifSimple);
        panStudent.add(panPuissanceSimple);

        panChoix.add(panStudent, BorderLayout.WEST);

        JPanel panObs = new JPanel();
        panObs.setBackground(Color.white);
        panObs.setPreferredSize(new Dimension((int) (dim.width * 0.467), (int) ((dim.height - 100) * 0.3)));
        panObs.setBorder(BorderFactory.createTitledBorder("Résultats"));

        panChoix.add(panObs, BorderLayout.EAST);

        this.getContentPane().add(panChoix);

        this.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                if (JOptionPane.showConfirmDialog(fen,
                        "Voulez-vous fermer l'application ?", "Fermeture ?",
                        JOptionPane.YES_NO_OPTION,
                        JOptionPane.QUESTION_MESSAGE) == JOptionPane.YES_OPTION) {
                    System.exit(0);
                } else {
                    FenetreSimple new_fen = new FenetreSimple("Fenetre Principale",
                            new Dimension(fen.getWidth(), fen.getHeight()), null, null, null, fen.getLocation(), cas);
                }
            }
        }
        );
    }
}
