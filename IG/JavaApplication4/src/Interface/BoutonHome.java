/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interface;

import java.awt.Image;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JOptionPane;

/**
 *
 * @author lairt
 */
public class BoutonHome extends JButton {

    public BoutonHome(final Fenetre fen_act, Boolean enabled) {
        super();

        try {
            Image img = ImageIO.read(getClass().getResource("home.png"));
            setIcon(new ImageIcon(img));
        } catch (IOException e) {

        }

        setEnabled(enabled);

        this.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent event) {
                if (JOptionPane.showConfirmDialog(fen_act,
                        "Voulez-vous revenir au menu principal ?", "Home ?",
                        JOptionPane.YES_NO_OPTION,
                        JOptionPane.QUESTION_MESSAGE) == JOptionPane.YES_OPTION) {
                    fen_act.setVisible(false);
                    fen_act.home.ret.setEnabled(false);
                    fen_act.home.next.setEnabled(false);
                    fen_act.home.setVisible(true);
                    fen_act.home.setSuiv(null);
                    fen_act.home.setPrec(null);
                    
                }
            }
        }
        );
    }
}
