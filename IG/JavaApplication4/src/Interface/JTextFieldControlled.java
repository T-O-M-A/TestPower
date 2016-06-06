/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Interface;

import javax.swing.JTextField;

/**
 *
 * @author lairt
 */
public class JTextFieldControlled extends JTextField {

    public JTextFieldControlled(String str) {
        super(str);
    }

    public JTextFieldControlled() {
        super();
    }

        boolean isInteger() {
        try {
            int i = Integer.parseInt(getText());
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }
    
    boolean isFloat() {
        try {
            float f = Float.parseFloat(getText());
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    boolean isBetween(float f1, float f2) {
        try {
            float f = Float.valueOf(getText());
            return (f >= f1 && f <= f2);
        } catch (NumberFormatException e) {
            return false;
        }
    }

    boolean isPositive() {
        try {
            float f = Float.valueOf(getText());
            return (f >= 0);
        } catch (NumberFormatException e) {
            return false;
        }
    }
}
