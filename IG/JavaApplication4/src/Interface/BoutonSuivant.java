/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interface;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JButton;

/**
 *
 * @author Lair Thomas, Bonjean Grégoire & Crépin Baptiste
 */
public class BoutonSuivant extends JButton {
        
    BoutonSuivant(String nom, Fenetre fen_act, Boolean enabled){
        super(nom);
        
        setEnabled(enabled);
        
        this.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent event) {
                fen_act.setVisible(false);
                fen_act.suiv.ret.setEnabled(true);
                fen_act.suiv.next.setEnabled(false);
                fen_act.suiv.setVisible(true);
                fen_act.suiv.setPrec(fen_act);
            }
        });
    }
}
