package com.madecontrol.projectpeopleandbusinessmonitoring.model.work;

import com.madecontrol.projectpeopleandbusinessmonitoring.model.info.Information;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.money.Currency;

public abstract class Work implements Information {

    private String name;
    private double salary;
    private Currency currency;

    protected Work(String name, double salary, Currency currency) {
        this.name = name;
        this.salary = salary;
        this.currency = currency;
    }

    public String getName() {
        return name;
    }

    public double getSalary() {
        return salary;
    }

    public Currency getCurrency() {
        return currency;
    }
}
