package com.madecontrol.projectpeopleandbusinessmonitoring.model.info;

import com.madecontrol.projectpeopleandbusinessmonitoring.model.business.Business;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.business.BusinessEntity;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.entity.Entity;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.entity.Man;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.entity.Organization;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.money.Currency;
import com.madecontrol.projectpeopleandbusinessmonitoring.model.money.MoneyStorage;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Stream;
import static com.madecontrol.projectpeopleandbusinessmonitoring.model.info.Information.*;

public final class Informations {

    private Informations() {
    }

    public static String addInfoBusiness(String info, Entity owner) {
        StringBuilder sb = new StringBuilder(info);
        Map<Entity, List<BusinessEntity>> businesses = Business.getBusinesses();

        if(!businesses.isEmpty() && businesses.containsKey(owner)) {

            sb.append(INFO_BUSINESS_TAG)
                    .append(System.lineSeparator());

            businesses.get(owner)
                    .forEach((business) -> sb.append(business.getInfoByOwner(owner))
                                             .append(System.lineSeparator()));
        }

        return sb.toString();
    }

    public static String addInfoMan(String info, Man man) {
        return info + String.format(INFO_MAN, man.getName()) + System.lineSeparator();
    }

    public static String addInfoOrganization(String info, Organization organization) {

        StringBuilder result = new StringBuilder(info);

        result.append(String.format(INFO_ORGANIZATION, organization.getName()));
        result.append(System.lineSeparator());

        organization.getOwners()
                .forEach((key, value) -> result.append(String.format(INFO_OWNER, key.getName(), (int) (value * 100)))
                                               .append(System.lineSeparator()));

        return result.toString();
    }

    public static String addInfoJobAndPosition(String info, Entity owner) {
        StringBuilder sb = new StringBuilder(info);
        Man man = (Man) owner;

        Stream.of(man.getJob(), man.getPosition())
                .filter(Objects::nonNull)
                .forEach((x) -> sb.append(x.getInfo())
                                  .append(System.lineSeparator()));
        return sb.toString();
    }

    public static String addInfoItem(String info, Entity owner) {

        StringBuilder sb = new StringBuilder(info);

        if(!owner.getItems().isEmpty()) {

            sb.append(INFO_ITEM_TAG)
                    .append(System.lineSeparator());

            owner.getItems().forEach((item) -> sb.append(item.getInfo())
                    .append(System.lineSeparator()));
        }

        return sb.toString();

    }

    public static String addInfoIncomeMoneyStorage(String info, Entity owner) {
        MoneyStorage incomeMoneyStorage = owner.getIncomeMoney();
        return addInfoMoneyStorage(info, incomeMoneyStorage, INFO_INCOME_MONEY_TAG);
    }

    public static String addInfoInvestMoneyStorage(String info, Entity owner) {
        MoneyStorage investMoneyStorage = owner.getInvestMoney();
        return addInfoMoneyStorage(info, investMoneyStorage, INFO_INVEST_MONEY_TAG);
    }

    private static String addInfoMoneyStorage(String info, MoneyStorage moneyStorage, String tag) {
        return info + tag + System.lineSeparator() + moneyStorage.getInfo() + System.lineSeparator();
    }
}
