<div align="center">
 <br/>
  <img src="docs/fuelGasEaterIcon.png" width="200" alt="Futer Logo" />
  <h1>Fuel Gas Eater</h1>
  <p>
    <b>Fuel Gas Eater</b> is a powerful tool for <b>reducing CO2 emissions</b> caused by transportation, <br/>
    such as commuting and business trips. It runs with <b>Net Zero Cloud</b>.
  </p>
  <p>
    This application is also published as a free managed package in <a href="https://appexchange.salesforce.com/appxListingDetail?listingId=8adc53d0-d5b9-40e0-9683-66b594961fc5">AppExchange</a>    
  </p>
  <br/>
</div>


## Installation

1. Set up enviroment. Follow the steps in the [Trailhead - Quick Start Lightning Web Component](https://trailhead.salesforce.com/content/learn/projects/quick-start-lightning-web-components/)

2. Authenticate with your DevHub Org.
```
sfdx force:auth:web:login -d -a [YOUR DEV HUB ORG ALIAS]
```

3. Clone the "Fuel Gas Eater" repository
```
git clone https://github.com/SalesforceLabs/Fuel-Gas-Eater
```

4. Move to the directory
```
cd Fuel-Gas-Eater/
```

5. Create a scratch org
```
sfdx force:org:create -s -f config/project-scratch-def.json -a fuelGasEaterScratch
```

6. Push source code to the scratch org
```
sfdx force:source:push -u fuelGasEaterScratch
```

7. Assign the permission set to the default user
```
sfdx force:user:permset:assign -n Fuel_Gas_Eater_User -u fuelGasEaterScratch
```
8. Open scratch org
```
sfdx force:org:open -u fuelGasEaterScratch
```

9. Click application launcher, select "Fuel Gas Eater" Application
!


## License
Fuel Gas Eater is available under the [BSD-3-Clause license](LICENSE.md)