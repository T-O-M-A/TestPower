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
            case "Regression":
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

                Image imgUn;
                 {
                    try {
                        imgUn = ImageIO.read(getClass().getResource("min_one_sample.png"));
                    } catch (IOException ex) {
                        imgUn = null;
                    }
                }

                JPanel panUn = new ImagePane(imgUn, 5, 15);
                panUn.setBackground(Color.white);
                panUn.setPreferredSize(new Dimension((int) (dim.width * 0.229), (int) ((dim.height - 100) * 0.162)));
                panUn.setBorder(BorderFactory.createTitledBorder("Un Échantillon"));
                panStudent.add(panUn);
                System.out.println((int) (dim.width * 0.229) + " " + (int) ((dim.height - 100) * 0.162));

                Image imgApp;
                 {
                    try {
                        imgApp = ImageIO.read(getClass().getResource("min_paired.png"));
                    } catch (IOException ex) {
                        imgApp = null;
                    }
                }

                JPanel panApp = new ImagePane(imgApp, 5, 15);
                panApp.setBackground(Color.white);
                panApp.setPreferredSize(new Dimension((int) (dim.width * 0.229), (int) ((dim.height - 100) * 0.162)));
                panApp.setBorder(BorderFactory.createTitledBorder("Deux Échantillons Appariés"));
                panStudent.add(panApp);

                Image imgInd;
                 {
                    try {
                        imgInd = ImageIO.read(getClass().getResource("min_indp.png"));
                    } catch (IOException ex) {
                        imgInd = null;
                    }
                }

                JPanel panInd = new ImagePane(imgInd, 5, 15);
                panInd.setBackground(Color.white);
                panInd.setPreferredSize(new Dimension((int) (dim.width * 0.229), (int) ((dim.height - 100) * 0.162)));
                panInd.setBorder(BorderFactory.createTitledBorder("Deux Échantillons Indépendants"));
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
                panCorr.add(panIntCorr);

                panAutre.add(panCorr, BorderLayout.NORTH);

                JPanel panAnova = new JPanel();
                panAnova.setBackground(Color.lightGray);
                panAnova.setPreferredSize(new Dimension((int) (dim.width * 0.467), (int) ((dim.height - 100) * 0.27)));
                panAnova.setBorder(BorderFactory.createTitledBorder("Test d'ANOVA"));
                panAutre.add(panAnova, BorderLayout.SOUTH);

                JPanel panIntAnova = new JPanel();
                panIntAnova.setBackground(Color.white);
                panIntAnova.setPreferredSize(new Dimension((int) (dim.width * 0.45), (int) ((dim.height - 100) * 0.215)));
                panAnova.add(panIntAnova);

                panChoix.add(panAutre, BorderLayout.EAST);
                break;

            case "Regression":

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
