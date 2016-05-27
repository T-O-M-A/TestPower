/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interface;

import java.awt.Color;
import java.awt.Dimension;
import java.io.IOException;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;

/**
 *
 * @author Lair Thomas, Bonjean Grégoire & Crépin Baptiste
 */
public class FenetreOuverture extends Fenetre {

    public FenetreOuverture(String title, Dimension dim, Fenetre prec, Fenetre suiv, Fenetre home) {
        super(title, dim, prec, suiv, home);
        this.getContentPane().add(new JLabel("Projet de Spécialité - Estimation de Puissance à Posteriori"));
        
        JPanel panCas = new JPanel();
        panCas.setBackground(Color.white);
        panCas.setPreferredSize(new Dimension((int) (dim.width*0.95), (int) ((dim.height-100)*0.9)));
        panCas.setBorder(BorderFactory.createTitledBorder("Choisissez un type de cas"));
        BoutonCasSimple boutonCasSimple = new BoutonCasSimple(this, true);
        panCas.add(boutonCasSimple);
                BoutonCasRegression boutonCasRegression = new BoutonCasRegression(this, true);
        panCas.add(boutonCasRegression);
                BoutonCasReel boutonCasReel= new BoutonCasReel(this, true);
        panCas.add(boutonCasReel);
              
        this.getContentPane().add(panCas);

    }

}
