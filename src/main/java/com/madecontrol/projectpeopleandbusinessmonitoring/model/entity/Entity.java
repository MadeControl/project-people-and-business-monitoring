package com.madecontrol.projectpeopleandbusinessmonitoring.model.entity;

import com.madecontrol.projectpeopleandbusinessmonitoring.model.info.Information;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.item.Item;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.money.MoneyStorage;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.money.MoneyStorageImpl;

import java.util.ArrayList;
import java.util.List;

public abstract class Entity implements Information {

    private String name;
    private MoneyStorage incomeMoney;
    private MoneyStorage investMoney;
    private List<Item> items;

    public Entity(String name) {
        this.name = name;
        this.incomeMoney = new MoneyStorageImpl();
        this.investMoney = new MoneyStorageImpl();
        this.items = new ArrayList<>();
    }

    public String getName() {
        return name;
    }

    public MoneyStorage getIncomeMoney() {
        return incomeMoney;
    }

    public MoneyStorage getInvestMoney() {
        return investMoney;
    }

    public List<Item> getItems() {
        return items;
    }

}
