/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interface;

/**
 *
 * @author Lair Thomas, Bonjean Grégoire & Crépin Baptiste
 */
import java.awt.*;
import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.IOException;
import java.util.LinkedList;
import javax.imageio.ImageIO;

public class Fenetre extends JFrame {

    public Fenetre fen;
    public String title;
    public Dimension dim;
    public JPanel pan;
    public BoutonRetour ret;
    public BoutonSuivant next;
    public Fenetre prec;
    public Fenetre suiv;
    public Fenetre home;

    public Fenetre(String title, Dimension dim, Fenetre prec, Fenetre suiv, Fenetre home) {

        fen = this;
        this.title = title;
        this.dim = dim;
        this.prec = prec;
        this.suiv = suiv;
        this.home = home;

        this.setTitle(title);
        this.setSize(dim);
        this.setLocationRelativeTo(null);

        this.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                if (JOptionPane.showConfirmDialog(fen,
                        "Voulez-vous fermer l'application ?", "Fermeture ?",
                        JOptionPane.YES_NO_OPTION,
                        JOptionPane.QUESTION_MESSAGE) == JOptionPane.YES_OPTION) {
                    System.exit(0);
                } else {
                    Fenetre fen = new FenetreOuverture("Fenetre Principale",
                new Dimension(700, 500), null, null, null);
                }
            }
        }
        );

        Font police = new Font("Arial", Font.BOLD, 14);

        pan = new JPanel();
        pan.setBackground(Color.white);
        pan.setPreferredSize(new Dimension(dim.width, 60));
        pan.setBorder(BorderFactory.createTitledBorder("Navigation"));

        this.setLayout(new FlowLayout());

        Boolean boolRetour;
        Boolean boolSuivant;
        Boolean boolHome;

        final BoutonRetour boutonRetour;
        final BoutonSuivant boutonSuivant;
        final BoutonHome boutonHome;

        if (this.prec == null) {
            boolRetour = false;
        } else {
            boolRetour = true;
        }

        if (this.prec == null) {
            boolSuivant = false;
        } else {
            boolSuivant = true;
        }

        if (this.home == null) {
            boolHome = false;
        } else {
            boolHome = true;
        }

        boutonRetour = new BoutonRetour("<<", this, boolRetour);
        boutonSuivant = new BoutonSuivant(">>", this, boolSuivant);
        boutonHome = new BoutonHome(this, boolHome);

        this.ret = boutonRetour;
        this.next = boutonSuivant;

        pan.add(boutonRetour);
        pan.add(boutonHome);
        pan.add(boutonSuivant);

        this.getContentPane().add(pan);

        this.setVisible(true);
    }

    public void setPrec(Fenetre fen) {
        this.prec = fen;
    }

    public void setSuiv(Fenetre fen) {
        this.suiv = fen;
    }

}
