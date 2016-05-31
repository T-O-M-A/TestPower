/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interface;

import java.awt.Dimension;

/**
 *
 * @author Lair Thomas, Bonjean Grégoire & Crépin Baptiste
 */
public class Interface {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        Fenetre fen = new FenetreOuverture("Menu Principal",
                new Dimension(1100, 400), null, null, null, null, true);
    }

}
