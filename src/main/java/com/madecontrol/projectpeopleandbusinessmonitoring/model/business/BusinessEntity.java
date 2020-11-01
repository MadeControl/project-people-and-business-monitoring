package com.madecontrol.projectpeopleandbusinessmonitoring.model.business;

import com.madecontrol.projectpeopleandbusinessmonitoring.model.entity.Entity;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.info.Information;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.money.Currency;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.money.MoneyStorage;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.owner.Owners;

import java.util.*;

public abstract class BusinessEntity implements Information {

    private static Map<Entity, List<BusinessEntity>> businesses = new HashMap<>();

    private String title;
    private double income;
    private Currency currencyIncome = Currency.USD;
    private int quantity = 1;

    private double price;
    private Currency currencyPrice = Currency.USD;

    private double bribe;

    private Map<Entity, Double> owners = new HashMap<>();

    private boolean controlledTaxes = false;
    private boolean arrested = false;

    public BusinessEntity(String title) {
        this.title = title;
    }

    public abstract String getInfoByOwner(Entity owner);

    public abstract double getTax();

    protected void addOwner(Entity owner, double coefficient) {
        Owners.addOwner(owners, owner, coefficient);
    }

    protected void addBusiness(Entity owner) {

        if (!businesses.containsKey(owner)) {
            businesses.put(owner, new ArrayList<>());
        }

        businesses.get(owner).add(this);

    }

    protected void addBribe(double moneyBribe, Currency currencyBribe) {
        moneyBribe = Currency.transferMoney(moneyBribe, currencyBribe, currencyIncome);
        bribe += moneyBribe;
    }

    protected void registrationBusiness(Entity owner) {

        this.addBusiness(owner);

        if(!this.arrested) {

            double coefficient = this.owners.get(owner);

            // add income money to owner money storage
            double money = (income * (controlledTaxes ? getTax() : 1.0) - bribe) * coefficient;
            Currency currency = this.currencyIncome;
            MoneyStorage moneyStorage = owner.getIncomeMoney();

            moneyStorage.addMoney(money, currency);

            // add invest money to owner money storage
            money = this.price * coefficient * this.quantity;
            currency = this.currencyPrice;
            moneyStorage = owner.getInvestMoney();

            moneyStorage.addMoney(money, currency);

        }

    }

    public String getTitle() {
        return title;
    }

    public int getQuantity() {
        return quantity;
    }

    public double getIncome() {
        return income;
    }

    public void setIncome(double income) {
        this.income = income;
    }

    public Currency getCurrencyIncome() {
        return currencyIncome;
    }

    public void setCurrencyIncome(Currency currencyIncome) {
        this.currencyIncome = currencyIncome;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public Currency getCurrencyPrice() {
        return currencyPrice;
    }

    public void setCurrencyPrice(Currency currencyPrice) {
        this.currencyPrice = currencyPrice;
    }

    public boolean isControlledTaxes() {
        return controlledTaxes;
    }

    public void setControlledTaxes(boolean controlledTaxes) {
        this.controlledTaxes = controlledTaxes;
    }

    public boolean isArrested() {
        return arrested;
    }

    public void setArrested(boolean arrested) {
        this.arrested = arrested;
    }

    public static Map<Entity, List<BusinessEntity>> getBusinesses() {
        return businesses;
    }

    public Map<Entity, Double> getOwners() {
        return owners;
    }

    public void setOwners(Map<Entity, Double> owners) {
        this.owners = owners;
    }

    public double getBribe() {
        return bribe;
    }
}
