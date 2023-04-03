public with sharing class FuelGasEaterUtils {
    
    private static final String KILOMETERS = 'Kilometers';
    private static final String MILES = 'Miles';
    private static final Decimal KM_TO_MILE = 0.62137119;
    private static final Decimal MILE_TO_KM = 1.609344;

    public static Decimal getEmission(Id aefId, Id gefId, Decimal distanceKm){
        if (distanceKm > 0){
            if (gefId != null && aefId == null){
                return getGroundTravelEmission(gefId, distanceKm);
            } else if (gefId == null && aefId != null){
                return getAirTravelEmission(aefId, distanceKm);
            }
        }
        return 0;
    }

    private static Decimal getAirTravelEmission(Id aefId, Decimal distanceKm){
        List<AirTravelEmssnFctr> aefs = Security.stripInaccessible(
            AccessType.READABLE, 
            [SELECT DistanceUnit, ShortHaulMaximumDistance, MediumHaulMaximumDistance, Co2PsgrKmLongHaulInKg, Co2PsgrKmMediumHaulInKg, Co2PsgrKmShortHaulInKg, Co2PsgrMileLongHaulInKg, Co2PsgrMileMediumHaulInKg, Co2PsgrMileShortHaulInKg FROM AirTravelEmssnFctr WHERE Id=:aefId LIMIT 1]
        ).getRecords();  
        Decimal ef = 0;
        if (aefs != null && aefs.size() == 1){
            AirTravelEmssnFctr aef = aefs.get(0);
            Decimal co2PsgrShortHaul = getEmissionFactorKm(aef.Co2PsgrKmShortHaulInKg, aef.Co2PsgrMileShortHaulInKg);
            Decimal co2PsgrMediumHaul = getEmissionFactorKm(aef.Co2PsgrKmMediumHaulInKg, aef.Co2PsgrMileMediumHaulInKg);
            Decimal co2PsgrLongHaul = getEmissionFactorKm(aef.Co2PsgrKmLongHaulInKg, aef.Co2PsgrMileLongHaulInKg);
            Decimal shortHaulMaximum = null;
            Decimal mediumHaulMaximum = null;
        
            if (aef.DistanceUnit == KILOMETERS){
                shortHaulMaximum = normalizeNumber(aef.ShortHaulMaximumDistance);
                mediumHaulMaximum = normalizeNumber(aef.MediumHaulMaximumDistance);
            } else if (aef.DistanceUnit == MILES){
                shortHaulMaximum = normalizeNumber(aef.ShortHaulMaximumDistance) * MILE_TO_KM;
                mediumHaulMaximum = normalizeNumber(aef.MediumHaulMaximumDistance) * MILE_TO_KM;
            }
            if (mediumHaulMaximum > 0){
                if (mediumHaulMaximum < distanceKm){
                    if (co2PsgrLongHaul != null && co2PsgrLongHaul > 0){
                        ef = co2PsgrLongHaul;
                    }
                } else {
                    if (co2PsgrMediumHaul != null && co2PsgrMediumHaul > 0){
                        ef = co2PsgrMediumHaul;
                    }
                }
            }
            if (shortHaulMaximum > 0){
                if (shortHaulMaximum > distanceKm){
                    if (co2PsgrShortHaul != null && co2PsgrShortHaul > 0){
                        ef = co2PsgrShortHaul;
                    }
                }
            }
            if ((mediumHaulMaximum > 0 && shortHaulMaximum > 0) == false){
                if (co2PsgrLongHaul != null && co2PsgrLongHaul > 0){
                    ef = co2PsgrLongHaul;
                }
                if (co2PsgrMediumHaul != null && co2PsgrMediumHaul > 0){
                    ef = co2PsgrMediumHaul;
                }
                if (co2PsgrShortHaul != null && co2PsgrShortHaul > 0){
                    ef = co2PsgrShortHaul;
                }   
            }
        }
        return ef * distanceKm;
    }
    private static Decimal getGroundTravelEmission(Id gefId, Decimal distanceKm){
        List<GroundTravelEmssnFctr> gefs = Security.stripInaccessible(
            AccessType.READABLE,
            [SELECT DistanceUnit, TaxiEmssnInKgCo2eDstnUnit, PersCarEmssnInKgCo2eDstnUnit, TrainEmssnInKgCo2eDstnUnit FROM GroundTravelEmssnFctr WHERE Id=:gefId LIMIT 1]
        ).getRecords();
        Decimal ef = 0;
        Decimal distance = 0;
        if (gefs != null && gefs.size() == 1){
            GroundTravelEmssnFctr gef = gefs.get(0);
            if (gef.DistanceUnit == KILOMETERS || gef.DistanceUnit == MILES){
                if (gef.TaxiEmssnInKgCo2eDstnUnit != null){
                    ef = gef.TaxiEmssnInKgCo2eDstnUnit;
                } else if (gef.PersCarEmssnInKgCo2eDstnUnit != null){
                    ef = gef.PersCarEmssnInKgCo2eDstnUnit;
                } else if (gef.TrainEmssnInKgCo2eDstnUnit != null){
                    ef = gef.TrainEmssnInKgCo2eDstnUnit;
                }
            } 
            if (gef.DistanceUnit == KILOMETERS){
                distance = distanceKm;
            } else if (gef.DistanceUnit == MILES){
                distance = distanceKm * KM_TO_MILE;
            }    
        }
        return ef * distance;
    }

    private static Decimal normalizeNumber(Decimal num){
        if (num != null){
            return num;
        }
        return 0;
    }

    private static Decimal getEmissionFactorKm(Decimal efKm, Decimal efMi){
        if (efKm != null){
            return efKm;
        } else if (efMi != null){
            return efMi * KM_TO_MILE;
        }
        return null;
    }

}