package com.madecontrol.projectpeopleandbusinessmonitoring.model.business;

import com.madecontrol.projectpeopleandbusinessmonitoring.model.entity.Entity;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.money.Currency;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.money.Taxes;

public class Rent extends BusinessEntity {

    private int quantitySquareMeters;
    private double pricePerOneSquareMeter;

    public Rent(String title) {
        super(title);
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
        Currency currencyPrice = getCurrencyPrice();
        Currency currencyIncome = getCurrencyIncome();

        double coefficient = getOwners().get(owner);
        double investedMoney = getPrice() * quantity * coefficient;
        Currency investCurrency = getCurrencyPrice();

        String info;

        if(!isArrested()) {

            boolean controlledTaxes = isControlledTaxes();
            int coefficientInt = (int) (coefficient * 100);

            double incomeMoney = (getIncome() * (controlledTaxes ? Taxes.getBusinessTax() : 1.0) - getBribe()) * coefficient;

            info = String.format(INFO_NOT_ARRESTED_RENT_BY_OWNER,
                    title, quantity, quantitySquareMeters, pricePerOneSquareMeter,
                    currencyIncome, coefficientInt, controlledTaxes, incomeMoney, currencyIncome);
        } else {

            info = String.format(INFO_ARRESTED_RENT_BY_OWNER,
                    title, quantity, price, currencyPrice, quantitySquareMeters,
                    pricePerOneSquareMeter, currencyIncome, investedMoney, investCurrency);

        }

        return info;
    }

    @Override
    public double getTax() {
        return Taxes.getRentTax();
    }

    private static double calculateIncome(int quantitySquareMeters, double pricePerOneSquareMeter, int quantityRents){
        return quantitySquareMeters * pricePerOneSquareMeter * quantityRents;
    }

    public static class Builder {

        private final Rent rent;

        public Builder(String title) {
            rent = new Rent(title);
        }

        public Builder income(int quantitySquareMeters, double pricePerOneSquareMeter, Currency currency, int quantityRent) {
            rent.setIncome(calculateIncome(quantitySquareMeters, pricePerOneSquareMeter, quantityRent));
            rent.setCurrencyIncome(currency);
            rent.quantitySquareMeters = quantitySquareMeters;
            rent.pricePerOneSquareMeter = pricePerOneSquareMeter;
            rent.setQuantity(quantityRent);
            return this;
        }

        public Builder price(int price, Currency currency) {
            rent.setPrice(price);
            rent.setCurrencyPrice(currency);
            return this;
        }

        public Builder owner(Entity owner, double coefficient) {
            rent.addOwner(owner, coefficient);
            return this;
        }

        public Builder giveBribe(double money, Currency currencyBribe, String description) {
            rent.addBribe(money, currencyBribe);
            return this;
        }

        public Builder controlledTaxes(boolean controlledTaxes) {
            rent.setControlledTaxes(controlledTaxes);
            return this;
        }

        public Builder arrested(boolean arrested) {
            rent.setArrested(arrested);
            return this;
        }


        public Rent build() {

            rent.getOwners().keySet()
                    .forEach(rent::registrationBusiness);

            return rent;
        }
    }

}
