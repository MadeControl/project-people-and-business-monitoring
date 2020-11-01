package com.madecontrol.projectpeopleandbusinessmonitoring.model.money;

public final class Taxes {

    public static final double BUSINESS_TAX = 0.18;
    public static final double INVESTMENT_TAX = 0.27;
    public static final double RENT_TAX = 0.23;

    private Taxes() {
    }

    public static double getBusinessTax() {
        return calculateTax(BUSINESS_TAX);
    }

    public static double getInvestmentTax() {
        return calculateTax(INVESTMENT_TAX);
    }

    public static double getRentTax() {
        return calculateTax(RENT_TAX);
    }

    private static double calculateTax(double taxCoefficient) {
        return 1 - taxCoefficient;
    }


}
