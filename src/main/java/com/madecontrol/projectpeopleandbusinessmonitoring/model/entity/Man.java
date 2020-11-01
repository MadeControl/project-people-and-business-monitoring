package com.madecontrol.projectpeopleandbusinessmonitoring.model.entity;

import com.madecontrol.projectpeopleandbusinessmonitoring.model.info.Informations;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.work.Job;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.work.Position;
import java.util.List;

public class Man extends Entity {

    private Job job;
    private Position position;

    public Man(String name) {
        super(name);
    }

    @Override
    public String getInfo() {

        String info = "";

        // Information about man name
        info = Informations.addInfoMan(info, this);

        // Information about job and position
        info = Informations.addInfoJobAndPosition(info, this);

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

    public Job getJob() {
        return job;
    }

    public Position getPosition() {
        return position;
    }

}
