package com.example;

public class App {
    public static void main(String[] args) {
        System.out.println("🚀 DevOps App Running Successfully!");
        while (true) {
            try {
                Thread.sleep(10000);
                System.out.println("App is still running...");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
