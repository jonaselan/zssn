ZSSN (Zombie Survival Social Network)

System for help non-infected people to share resources

## Requirements

* [Ruby](https://www.ruby-lang.org) (2.3.0 used)
* [Rails](http://rubyonrails.org/)

The application is deploy [here](https://www.heroku.com/). But if you are using locally, is important fill the default resources after the `rails db:migration` and `bundle`. For do that,  run:
```
rails db:seed
```

## Routes

### Survivors

**POST**  to register a new survivor.


```
api/survivors

{
  "name": "Zezinho",
  "age": 30,
  "gender": "M",
  "latitude": "-16.346867430274",
  "longitude": "-48.948227763174",
  "infected": false,
  "infection_occurrences": 0,
  "inventory_attributes": {
  		"inventory_resources_attributes": [{
  			"resource_id": 1,
    		"resource_id": 2,
    		 ...
  		 }]
  	}
}
```
Follow this table of values for assignment the resource to survivor

| Item | Points |
| ------ | ------ |
| Ammuntion | 1 point |
| Medication | 2 points |
| Food | 3 points |
| Water | 4 points |


**PUT** to update a survivor information
```
/api/survivors

{
    "name": "Zezo",
    ...
}
```

**GET** to report a survivor as infected.

```
/api/survivors/{id}/report_infection
```


**PUT** to trade items between survivors.
```
api/survivors/{id}/trade/{survivor1_id}/{resources1}/{survivor2_id}/{resources2}

```

The resources should follow the pattern `count:resource,count:resources,..` (e.g. 1:ammunition,1:food or 1:water)


### Reports

**GET** Percentage of infected survivors.
```
/api/reports/avg_infected
```

**GET** Percentage of non-infected survivors.
```
/api/reports/avg_non_infected
```

**GET** Average amount of each kind of resource by survivor
```
/api/reports/avg_resource_per_person
```
**GET**  Points lost because of infected survivor
```
/api/reports/points_lost_infected`
```
