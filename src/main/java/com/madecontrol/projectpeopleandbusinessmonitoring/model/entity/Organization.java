package com.madecontrol.projectpeopleandbusinessmonitoring.model.entity;

import com.madecontrol.projectpeopleandbusinessmonitoring.model.info.Informations;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.item.ItemImpl;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.money.Currency;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.owner.Owners;

import java.util.HashMap;
import java.util.Map;

public class Organization extends Entity {

    private Map<Entity, Double> owners;

    public Organization(String name) {
        super(name);
        owners = new HashMap<>();
    }

    @Override
    public String getInfo() {
        String info = "";

        // Information about organization name
        info = Informations.addInfoOrganization(info, this);

        // Information about personal items
        info = Informations.addInfoItem(info, this);

        // Information about business
        info = Informations.addInfoBusiness(info, this);

        // Information about income money storage
        info = Informations.addInfoIncomeMoneyStorage(info, this);

        // Information about invest money storage
        info = Informations.addInfoInvestMoneyStorage(info, this);

        return info;
    }

    public Map<Entity, Double> getOwners() {
        return owners;
    }

}
