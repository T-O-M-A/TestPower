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
public class BoutonRetour extends JButton {
    
    BoutonRetour(String nom, final Fenetre fen_act, Boolean enabled){
        super(nom);
        
        setEnabled(enabled);
        
        this.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent event) {
                fen_act.setVisible(false);
                fen_act.prec.ret.setEnabled(true);
                fen_act.prec.next.setEnabled(false);
                fen_act.prec.setVisible(true);
                fen_act.prec.setSuiv(fen_act);
            }
        });
    }
}
