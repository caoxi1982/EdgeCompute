package com.ra.demo.plc4x;

import java.util.Scanner;

/**
 * Hello world!
 *
 */
public class App 
{
    public static void main( String[] args )
    {
        boolean exit = true;
        System.out.println( "Hello World!" );
        Scanner sc = new Scanner(System.in);
        while(exit){
            int temp = sc.nextInt();
            if (temp == 100) {
                exit = false;
            }
            System.out.println("Type = " + temp );
        } 
        sc.close();
        
    }
}
