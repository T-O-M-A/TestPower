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
import java.io.IOException;
import javax.swing.BorderFactory;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import static javax.swing.border.TitledBorder.CENTER;

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

        JPanel panCas = new JPanel();
        panCas.setBackground(Color.white);
        panCas.setPreferredSize(new Dimension((int) (dim.width * 0.95), (int) ((dim.height - 100) * 0.8)));
        panCas.setBorder(BorderFactory.createTitledBorder("Cas : " + cas));

        JLabel image;
        switch (cas) {
            case "simple":
                image = new JLabel(new ImageIcon("loi_n.png"));                
                break;
            case "regression":
                image = new JLabel(new ImageIcon("linear_r.png")); 
                break;
            default:
                image = new JLabel(new ImageIcon("donnees.png")); 
                break;
        }
        panCas.add(image);

        JPanel panDescr = new JPanel();
        panDescr.setBackground(Color.white);
        panDescr.setPreferredSize(new Dimension((int) (dim.width * 0.50), (int) ((dim.height - 100) * 0.4)));
        panDescr.setBorder(BorderFactory.createTitledBorder("Description"));
        panCas.add(panDescr);
        
        this.getContentPane().add(panCas);
        
        JPanel panChoix = new JPanel();
        panChoix.setBackground(Color.white);
        panChoix.setPreferredSize(new Dimension((int) (dim.width * 0.95), (int) ((dim.height - 100) * 0.8)));
        panChoix.setBorder(BorderFactory.createTitledBorder("Choisissez un sous-type de cas"));
        
        
        
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
