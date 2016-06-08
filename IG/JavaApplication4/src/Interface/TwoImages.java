/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interface;

import java.awt.Image;

/**
 *
 * @author thomas
 */
public class TwoImages {
    Image pilote;
    Image puissance;
    
    public TwoImages() {
        pilote = null;
        puissance = null;
    }
    
    public TwoImages(Image pilote, Image puissance) {
        this.pilote = pilote;
        this.puissance = puissance;
    }
    
    public Image getPilote() {
        return pilote;
    }
    
    public Image getPuissance() {
        return puissance;
    }
}
