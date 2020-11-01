package com.madecontrol.projectpeopleandbusinessmonitoring.model.money;

public enum Currency {

    USD(27.0), EUR(31.0), UAH(1.0), RUR(0.38);

    private double price;

    Currency(double price) {
        this.price = price;
    }

    public double price() {
        return price;
    }

    public static double transferMoney(double money, Currency currencyBefore, Currency currencyAfter) {
        return money * (currencyBefore.price / currencyAfter.price);
    }
}
