/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interface;

import java.awt.*;
import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 *
 * @author thomas
 */
public class FenetreErreur extends JDialog {

    public FenetreErreur(String name, final JButton bouton, String string) {
        this.setTitle(name);
        this.setSize(400, 150);
        this.setLocationRelativeTo(null);
        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        JPanel pan = new JPanel();
        this.setContentPane(pan);

        Font police = new Font("Arial", Font.BOLD, 14);

        JLabel label = new JLabel(string);
        pan.add(label);
        
        JPanel panFill = new JPanel();
        panFill.setPreferredSize(new Dimension(400, 10));
        this.getContentPane().add(panFill);
        
        JButton boutonSortie = new JButton("Ok");
        boutonSortie.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent event) {
                bouton.setEnabled(true);
                setVisible(false);
            }
        });
        this.getContentPane().add(boutonSortie);

        this.addWindowListener(new java.awt.event.WindowAdapter() {
            @Override
            public void windowClosing(java.awt.event.WindowEvent windowEvent) {
                    bouton.setEnabled(true);
                    setVisible(false);
            }
        });
        this.setContentPane(pan);
        this.setVisible(true);
    }
}