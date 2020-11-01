package com.madecontrol.projectpeopleandbusinessmonitoring.model.business;

import com.madecontrol.projectpeopleandbusinessmonitoring.model.entity.Entity;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.money.Currency;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.money.Taxes;
import java.security.SecureRandom;
import java.util.Random;

public class Business extends BusinessEntity {

    public Business(String title) {
        super(title);
    }

    private double calculateIncome(int minIncome, int maxIncome, int quantity) {

        Random random = new SecureRandom();
        int income = 0;

        for (int i = 0; i < quantity; i++) {
            income += minIncome + random.nextInt(maxIncome - minIncome + 1);
        }

        return income;
    }

    @Override
    public double getTax() {
        return Taxes.getBusinessTax();
    }

    @Override
    public String getInfo() {
        return null;
    }

    @Override
    public String getInfoByOwner(Entity owner) {

        String title = getTitle();
        int quantity = getQuantity();
        double price = getPrice();
        Currency priceCurrency = getCurrencyPrice();
        double coefficient = getOwners().get(owner);
        double investedMoney = price * quantity * coefficient;

        String info;

        if(!isArrested()) {

            boolean controlledTaxes = isControlledTaxes();

            double incomeMoney = (getIncome() * (controlledTaxes ? Taxes.getBusinessTax() : 1.0) - getBribe()) * coefficient;

            Currency incomeCurrency = getCurrencyIncome();

            int coefficientInt = (int) (coefficient * 100);

            info = String.format(INFO_NOT_ARRESTED_BUSINESS_BY_OWNER,
                    title, quantity, price, priceCurrency, coefficientInt,
                    controlledTaxes, investedMoney, priceCurrency, incomeMoney, incomeCurrency);

        } else {

            info = String.format(INFO_ARRESTED_BUSINESS_BY_OWNER,
                    title, quantity, price, priceCurrency, investedMoney, priceCurrency);

        }

        return info;

    }

    public static class Builder {

        private final Business business;

        public Builder(String title) {
            this.business = new Business(title);
        }

        public Builder income(int minIncome, int maxIncome, Currency currency, int quantity) {
            double income = business.calculateIncome(minIncome, maxIncome, quantity);
            business.setIncome(income);
            business.setCurrencyIncome(currency);
            business.setQuantity(quantity);
            return this;
        }

        public Builder price(int price, Currency currency) {
            business.setPrice(price);
            business.setCurrencyPrice(currency);
            return this;
        }

        public Builder owner(Entity owner, double coefficient) {
            business.addOwner(owner, coefficient);
            return this;
        }

        public Builder giveBribe(double money, Currency currencyBribe, String description) {
            business.addBribe(money, currencyBribe);
            return this;
        }

        public Builder controlledTaxes(boolean controlledTaxes) {
            business.setControlledTaxes(controlledTaxes);
            return this;
        }

        public Builder arrested(boolean arrested) {
            business.setArrested(arrested);
            return this;
        }

        public Business build() {

            business.getOwners().keySet()
                    .forEach(business::registrationBusiness);

            return business;
        }

    }
}
