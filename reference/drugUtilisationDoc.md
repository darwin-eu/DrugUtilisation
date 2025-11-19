# Helper for consistent documentation of `add`/`summariseDrugUtilisation` functions.

Helper for consistent documentation of `add`/`summariseDrugUtilisation`
functions.

## Arguments

- numberExposures:

  Whether to include 'number_exposures' (number of drug exposure records
  between indexDate and censorDate).

- numberEras:

  Whether to include 'number_eras' (number of continuous exposure
  episodes between indexDate and censorDate).

- daysExposed:

  Whether to include 'days_exposed' (number of days that the individual
  is in a continuous exposure episode, including allowed treatment gaps,
  between indexDate and censorDate; sum of the length of the different
  drug eras).

- daysPrescribed:

  Whether to include 'days_prescribed' (sum of the number of days for
  each prescription that contribute in the analysis).

- timeToExposure:

  Whether to include 'time_to_exposure' (number of days between
  indexDate and the first episode).

- initialExposureDuration:

  Whether to include 'initial_exposure_duration' (number of prescribed
  days of the first drug exposure record).

- initialQuantity:

  Whether to include 'initial_quantity' (quantity of the first drug
  exposure record).

- cumulativeQuantity:

  Whether to include 'cumulative_quantity' (sum of the quantity of the
  different exposures considered in the analysis).

- initialDailyDose:

  Whether to include 'initial_daily_dose\_{unit}' (daily dose of the
  first considered prescription).

- cumulativeDose:

  Whether to include 'cumulative_dose\_{unit}' (sum of the cumulative
  dose of the analysed drug exposure records).

- exposedTime:

  deprecated.
