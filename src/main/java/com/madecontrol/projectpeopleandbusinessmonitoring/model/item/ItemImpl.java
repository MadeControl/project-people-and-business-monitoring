package com.madecontrol.projectpeopleandbusinessmonitoring.model.item;

import com.madecontrol.projectpeopleandbusinessmonitoring.model.money.Currency;

public class ItemImpl implements Item {

    private String name;
    private double price;
    private Currency currency;
    private int amount;

    public ItemImpl(String name, double price, Currency currency, int amount) {
        this.name = name;
        this.price = price;
        this.currency = currency;
        this.amount = amount;
    }

    @Override
    public String getInfo() {
        return String.format(INFO_ITEM, name, price, currency, amount, amount * price, currency);
    }

    @Override
    public double getFullPrice() {
        return price * amount;
    }

    @Override
    public Currency getCurrency() {
        return currency;
    }
}
