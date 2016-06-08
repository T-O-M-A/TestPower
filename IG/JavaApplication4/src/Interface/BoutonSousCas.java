/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interface;

import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JButton;
import org.rosuda.JRI.Rengine;

/**
 *
 * @author lairt
 */
public class BoutonSousCas extends JButton {

    public BoutonSousCas(final Fenetre fen_act,
            final String cas,
            final Rengine eng) {
        super("Choisir");

        this.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent event) {
                fen_act.setVisible(false);
                Fenetre new_fen = new FenetreSimple(cas,
                        new Dimension(1100, 750),
                        fen_act,
                        null,
                        fen_act.home,
                        null,
                        cas,
                        eng);
                new_fen.ret.setEnabled(true);
                new_fen.next.setEnabled(false);
            }
        }
        );
    }
}
