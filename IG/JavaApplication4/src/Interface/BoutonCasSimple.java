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

/**
 *
 * @author lairt
 */
public class BoutonCasSimple extends JButton {

    public BoutonCasSimple(final Fenetre fen_act, Boolean enabled) {
        super();

        try {
            Image img = ImageIO.read(getClass().getResource("loi_n.png"));
            setIcon(new ImageIcon(img));
        } catch (IOException e) {

        }

        setEnabled(enabled);

        this.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent event) {
                fen_act.setVisible(false);
                fen_act.prec.ret.setEnabled(true);
                fen_act.prec.next.setEnabled(true);
                fen_act.prec.setVisible(true);
                fen_act.prec.setSuiv(fen_act);
            }
        }
        );
    }
}
