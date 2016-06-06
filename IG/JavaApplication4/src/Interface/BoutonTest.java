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

/**
 *
 * @author lairt
 */
public class BoutonTest extends JButton {

    public BoutonTest(final Fenetre fen_act) {
        super("Vérification du Test");

        this.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent event) {
                fen_act.setVisible(false);
                FenetreCas new_fen = new FenetreCas("Cas Réel",
                        new Dimension(1100, 650),
                        fen_act,
                        null,
                        fen_act.home,
                        null,
                        "Réel");
                new_fen.ret.setEnabled(true);
                new_fen.next.setEnabled(false);
            }
        }
        );
    }
}
