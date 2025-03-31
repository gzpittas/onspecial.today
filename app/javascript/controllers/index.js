// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)


// app/javascript/controllers/index.js
import { application } from "./application"

import SelectController from "./select_controller"
application.register("select", SelectController)

import PriceCalculatorController from "./price_calculator_controller"
application.register("price-calculator", PriceCalculatorController)