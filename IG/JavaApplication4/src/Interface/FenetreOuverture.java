/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interface;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Point;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import javax.swing.BorderFactory;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import org.rosuda.JRI.Rengine;
import org.rosuda.REngine.REngine;

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
            Point location,
            Boolean bool,
            final Rengine eng) {
        super(title, dim, prec, suiv, home, location);
        fen = this;
        this.getContentPane().add(new JLabel("Projet de Spécialité - Estimation de Puissance à Posteriori"));
     
        JPanel panCas = new JPanel();
        panCas.setBackground(Color.white);
        panCas.setPreferredSize(new Dimension((int) (dim.width * 0.95), (int) ((dim.height - 100) * 0.8)));
        panCas.setBorder(BorderFactory.createTitledBorder("Choisissez un type de cas"));

        JPanel panSimple = new JPanel();
        panSimple.setBackground(Color.white);
        panSimple.setPreferredSize(new Dimension((int) (dim.width * 0.305), (int) ((dim.height - 100) * 0.675)));
        JLabel labelSimple = new JLabel("Cas Simples");
        BoutonCasSimple boutonCasSimple = new BoutonCasSimple(this, true, eng);
        panSimple.add(labelSimple);
        panSimple.add(boutonCasSimple);

        JPanel panReg = new JPanel();
        panReg.setBackground(Color.white);
        panReg.setPreferredSize(new Dimension((int) (dim.width * 0.305), (int) ((dim.height - 100) * 0.675)));
        JLabel labelReg = new JLabel("Cas Regressions");
        BoutonCasRegression boutonCasRegression = new BoutonCasRegression(this, true, eng);
        panReg.add(labelReg);
        panReg.add(boutonCasRegression);

        JPanel panReel = new JPanel();
        panReel.setBackground(Color.white);
        panReel.setPreferredSize(new Dimension((int) (dim.width * 0.305), (int) ((dim.height - 100) * 0.675)));
        JLabel labelReel = new JLabel("Cas Réel");
        BoutonCasReel boutonCasReel = new BoutonCasReel(this, true, eng);
        panReel.add(labelReel);
        panReel.add(boutonCasReel);

        panCas.add(panSimple);
        panCas.add(panReg);
        panCas.add(panReel);
        
        this.getContentPane().add(panCas);

        this.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                if (JOptionPane.showConfirmDialog(fen,
                        "Voulez-vous fermer l'application ?", "Fermeture ?",
                        JOptionPane.YES_NO_OPTION,
                        JOptionPane.QUESTION_MESSAGE) == JOptionPane.YES_OPTION) {
                    eng.end();
                    System.exit(0);
                } else {
                    FenetreOuverture new_fen = new FenetreOuverture("Fenetre Principale",
                            new Dimension(fen.getWidth(), fen.getHeight()), fen.prec, fen.suiv, fen.home, fen.getLocation(), false, eng);

                }
            }
        }
        );
    }

}
