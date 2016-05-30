/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interface;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Point;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.IOException;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

/**
 *
 * @author Lair Thomas, Bonjean Grégoire & Crépin Baptiste
 */
public class FenetreOuverture extends Fenetre {

    public FenetreOuverture(String title,
            Dimension dim,
            Fenetre prec,
            Fenetre suiv,
            Fenetre home,
            Point location) {
        super(title, dim, prec, suiv, home, location);
        fen = this;
        this.getContentPane().add(new JLabel("Projet de Spécialité - Estimation de Puissance à Posteriori"));

        JPanel panCas = new JPanel();
        panCas.setBackground(Color.white);
        panCas.setPreferredSize(new Dimension((int) (dim.width * 0.95), (int) ((dim.height - 100) * 0.8)));
        panCas.setBorder(BorderFactory.createTitledBorder("Choisissez un type de cas"));

        JLabel labSimple = new JLabel("------------------------ Cas Simples -----------------------------------------------");
        panCas.add(labSimple);
        JLabel labRegression = new JLabel("Cas Regressions ----------------------------------------------");
        panCas.add(labRegression);
        JLabel labReel = new JLabel("Cas Réel ---------------------------");
        panCas.add(labReel);

        BoutonCasSimple boutonCasSimple = new BoutonCasSimple(this, true);
        panCas.add(boutonCasSimple);
        BoutonCasRegression boutonCasRegression = new BoutonCasRegression(this, true);
        panCas.add(boutonCasRegression);
        BoutonCasReel boutonCasReel = new BoutonCasReel(this, true);
        panCas.add(boutonCasReel);

        this.getContentPane().add(panCas);

        this.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                if (JOptionPane.showConfirmDialog(fen,
                        "Voulez-vous fermer l'application ?", "Fermeture ?",
                        JOptionPane.YES_NO_OPTION,
                        JOptionPane.QUESTION_MESSAGE) == JOptionPane.YES_OPTION) {
                    System.exit(0);
                } else {
                    FenetreOuverture new_fen = new FenetreOuverture("Fenetre Principale",
                            new Dimension(fen.getWidth(), fen.getHeight()), null, null, null, fen.getLocation());
                }
            }
        }
        );
    }

}
