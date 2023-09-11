<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xsl:version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml" xmlns:fhir="http://hl7.org/fhir">

    <!-- Root template -->
    <xsl:template match="/">
        <html
            lang="en">
            <head>
                <title>
                    GP Connect - Update Record - Example patient activity (XSLT)
                </title>
                <link rel="stylesheet" href="./gpc-update-record.css" type="text/css" />
            </head>
            <body>
                <div class="wrapper">
                    <div class="title-banner">
                        <div class="banner-text">
                            <h1>GP Connect</h1>
                        </div>
                        <div class="banner-logo">
                            <img src="nhs-logo-transparent.png" />
                        </div>
                    </div>
                    <xsl:apply-templates mode="patient" />
                    <xsl:apply-templates mode="encounter" />
                    <xsl:apply-templates mode="presenting-complaints-or-issues" />
                    <xsl:apply-templates mode="safeguarding" />
                    <xsl:apply-templates mode="plan-and-requested-actions" />
                    <xsl:apply-templates mode="medications" />
                    <xsl:apply-templates mode="clinical-summary" />
                    <xsl:apply-templates mode="relevant-history-information-requested" />
                    <xsl:apply-templates mode="information-and-advice-given" />
                    <xsl:apply-templates mode="signpost-details" />

                    <xsl:apply-templates mode="observations" />

                    <div class="prsb-heading-banner metadata">
                        Organisation(s)
                    </div>
                    <xsl:apply-templates mode="organisations" />

                    <div class="prsb-heading-banner metadata">
                        Healthcare profesional(s)
                    </div>
                    <xsl:apply-templates mode="hcp" />

                    <div class="prsb-heading-banner metadata">
                        Practiotioner Role(s)
                    </div>
                    <xsl:apply-templates mode="practitioner-role" />
                    
                </div>
            </body>
        </html>
    </xsl:template>

    <!-- Patient -->
    <xsl:template mode="patient" match="fhir:Patient">

        <!-- Surname -->
        <xsl:variable name="surname"
            select="fhir:name/fhir:family/@value"></xsl:variable>

        <!-- Forename -->
        <xsl:variable name="forename"
            select="fhir:name/fhir:given/@value"></xsl:variable>

        <!-- DOB -->
        <xsl:variable name="birthDate"
            select="fhir:birthDate/@value"></xsl:variable>

        <!-- Gender -->
        <xsl:variable name="gender"
            select="fhir:gender/@value"></xsl:variable>

        <!-- NHS Number -->
        <xsl:variable name="nhsNumber"
            select="fhir:identifier/fhir:value/@value"></xsl:variable>

        <div class="patient-banner">
            <div class="patient-name">
                <strong><xsl:value-of select="$surname" />, <xsl:value-of select="$forename" /></strong>
            </div>
            <div class="patient-metadata"> Born: <strong>
                    <xsl:value-of select="$birthDate" />
                </strong>, Gender: <strong>
                    <span class="capitalise-text"><xsl:value-of select="$gender" /></span>
                </strong>, NHS No: <strong>
                    <xsl:value-of select="$nhsNumber" />
                </strong>
            </div>
        </div>
    </xsl:template>

    <!-- Encounter -->
    <xsl:template mode="encounter" match="fhir:Encounter">

        <!-- Encounter reason -->
        <xsl:variable name="encounterReason"
            select="fhir:reason/fhir:text/@value"></xsl:variable>

        <!-- Encounter date -->
        <xsl:variable
            name="encounterPeriodStart" select="fhir:period/fhir:start/@value"></xsl:variable>
        <xsl:variable
            name="encounterPeriodEnd" select="fhir:period/fhir:end/@value"></xsl:variable>

        <!-- Encounter type -->
        <xsl:variable
            name="encounterType" select="fhir:type/fhir:coding/fhir:display/@value"></xsl:variable>

        <!-- Encounter status -->
        <xsl:variable
            name="encounterStatus" select="fhir:status/@value"></xsl:variable>

        <!-- Encounter outcome of attendance -->
        <xsl:variable
            name="encounterOutcomeOfAttendance"
            select="fhir:extension[@url='https://fhir.hl7.org.uk/STU3/StructureDefinition/Extension-CareConnect-OutcomeOfAttendance-1']/fhir:valueCodeableConcept/fhir:text/@value"></xsl:variable>

        <div
            class="encounter-banner">
            <div class="reason">
                <strong>Encounter</strong>
            </div>
        </div>
        <div class="prsb-content">
            <table>
                <!-- Date -->
                <tr>
                    <td class="nhs-pale-grey">Date</td>
                    <td>
                        <xsl:value-of select="$encounterPeriodStart" />
                        <xsl:if test="$encounterPeriodEnd"> - <xsl:value-of
                                select="$encounterPeriodEnd" />
                        </xsl:if>
                    </td>
                </tr>
                <!-- Reason -->
                <tr>
                    <td class="nhs-pale-grey">Reason</td>
                    <td>
                        <xsl:value-of select="$encounterReason" />
                    </td>
                </tr>
                <!-- Type -->
                <tr>
                    <td class="nhs-pale-grey">Type</td>
                    <td>
                        <xsl:value-of select="$encounterType" />
                    </td>
                </tr>
                <!-- Status -->
                <tr>
                    <td class="nhs-pale-grey">Status</td>
                    <td>
                        <xsl:value-of select="$encounterStatus" />
                    </td>
                </tr>
                <!-- Outcome of attendance -->
                <xsl:if test="$encounterOutcomeOfAttendance">
                    <tr>
                        <td class="nhs-pale-grey">Outcome of attendance</td>
                        <td>
                            <xsl:value-of select="$encounterOutcomeOfAttendance" />
                        </td>
                    </tr>
                </xsl:if>
            </table>
        </div>
    </xsl:template>


    <!-- Presenting complaints or issues -->
    <xsl:template mode="presenting-complaints-or-issues" match="fhir:Condition">

        <!-- Condition code -->
        <xsl:variable
            name="conditionCode" select="fhir:code/fhir:coding/fhir:display/@value"></xsl:variable>
        <xsl:variable
            name="conditionClinicalStatus" select="fhir:clinicalStatus/@value"></xsl:variable>
        <xsl:variable
            name="conditionAssertedDate" select="fhir:assertedDate/@value"></xsl:variable>

        <div
            class="prsb-heading-banner presenting-complaints-or-issues">
            Presenting complaints or issues
        </div>
        <div class="prsb-content">
            <table>
                <tr>
                    <td class="nhs-pale-grey">Condition</td>
                    <td>
                        <xsl:value-of select="$conditionCode" />
                    </td>
                </tr>
                <!-- <tr>
                    <td class="nhs-pale-grey">Clinical status</td>
                    <td>
                        <xsl:value-of select="$conditionClinicalStatus" />
                    </td>
                </tr> -->
                <tr>
                    <td class="nhs-pale-grey">Asserted date</td>
                    <td>
                        <xsl:value-of select="$conditionAssertedDate" />
                    </td>
                </tr>
            </table>
        </div>
    </xsl:template>


    <!-- Safeguarding -->
    <xsl:template mode="safeguarding" match="fhir:Flag">

        <xsl:if test="fhir:meta/fhir:tag/fhir:code[@value='safeguarding']">
            <!-- Safeguarding concern -->
            <xsl:variable
                name="safeguardingConcern" select="fhir:code/fhir:coding/fhir:display/@value"></xsl:variable>

            <div
                class="prsb-heading-banner safeguarding">
                Safeguarding
            </div>
            <div class="prsb-content">
                <table>
                    <tr>
                        <td class="nhs-pale-grey">Concern</td>
                        <td>
                            <xsl:value-of select="$safeguardingConcern" />
                        </td>
                    </tr>
                </table>
            </div>
        </xsl:if>

    </xsl:template>

    <!-- Clinical summary -->
    <xsl:template mode="clinical-summary" match="fhir:ClinicalImpression">

        <xsl:if test="fhir:meta/fhir:tag/fhir:code[@value='clinical-summary']">
            <xsl:variable name="clinicalSummary" select="fhir:summary/@value"></xsl:variable>
            <div
                class="prsb-heading-banner">
                Clinical summary
            </div>
            <div class="prsb-content">
                <table>
                    <tr>
                        <td>
                            <xsl:value-of select="$clinicalSummary" />
                        </td>
                    </tr>
                </table>
            </div>
        </xsl:if>

    </xsl:template>

    <!-- Information and advice given -->
    <xsl:template mode="information-and-advice-given" match="fhir:ClinicalImpression">

        <xsl:if test="fhir:meta/fhir:tag/fhir:code[@value='information-and-advice-given']">
            <xsl:variable name="informationAndAdviceGiven" select="fhir:summary/@value"></xsl:variable>
            <div
                class="prsb-heading-banner">
                Information and advice given
            </div>
            <div
                class="prsb-content">
                <table>
                    <tr>
                        <td>
                            <xsl:value-of select="$informationAndAdviceGiven" />
                        </td>
                    </tr>
                </table>
            </div>
        </xsl:if>

    </xsl:template>

    <!-- Signpost details -->
    <xsl:template mode="signpost-details" match="fhir:ClinicalImpression">

        <xsl:if test="fhir:meta/fhir:tag/fhir:code[@value='signpost-details']">
            <xsl:variable name="signpostDetails" select="fhir:summary/@value"></xsl:variable>
            <div
                class="prsb-heading-banner">
                Signpost details
            </div>
            <div class="prsb-content">
                <table>
                    <tr>
                        <td>
                            <xsl:value-of select="$signpostDetails" />
                        </td>
                    </tr>
                </table>
            </div>
        </xsl:if>

    </xsl:template>


    <!-- Relevant-history-information-requested -->
    <xsl:template mode="relevant-history-information-requested" match="fhir:ClinicalImpression">

        <xsl:if test="fhir:meta/fhir:tag/fhir:code[@value='history']">
            <xsl:variable name="relevantHistoryInformationRequested" select="fhir:summary/@value"></xsl:variable>
            <div
                class="prsb-heading-banner">
                Relevant history / information requested
            </div>
            <div
                class="prsb-content">
                <table>
                    <tr>
                        <td>
                            <xsl:value-of select="$relevantHistoryInformationRequested" />
                        </td>
                    </tr>
                </table>
            </div>
        </xsl:if>

    </xsl:template>

    <!-- Plan and requested actions-->
    <xsl:template mode="plan-and-requested-actions" match="fhir:ClinicalImpression">

        <xsl:if test="fhir:meta/fhir:tag/fhir:code[@value='plan-and-requested-actions']">
            <xsl:variable name="planAndRequestedActions" select="fhir:summary/@value"></xsl:variable>
            <div
                class="prsb-heading-banner plan-and-requested-actions">
                Plan and requested actions
            </div>
            <div
                class="prsb-content">
                <table>
                    <tr>
                        <td>
                            <xsl:value-of select="$planAndRequestedActions" />
                        </td>
                    </tr>
                </table>
            </div>
        </xsl:if>

    </xsl:template>

    <!-- Medications and medical devices -->
    <xsl:template mode="medications" match="fhir:MedicationDispense">

        <!-- Medication name -->
        <xsl:variable
            name="medicationName"
            select="fhir:medicationCodeableConcept/fhir:coding/fhir:display/@value" />

        <!-- Supply integer -->
        <xsl:variable
            name="supplyInteger" select="fhir:daysSupply/fhir:value/@value" />

        <!-- Supply uom -->
        <xsl:variable
            name="supplyUom" select="fhir:daysSupply/fhir:code/@value" />

        <!-- Patient instruction -->
        <xsl:variable
            name="patientInstruction" select="fhir:dosageInstruction/fhir:patientInstruction/@value" />

        <!-- When prepared -->
        <xsl:variable
            name="whenPrepared" select="fhir:whenPrepared/@value" />

        <!-- When handed over -->
        <xsl:variable
            name="whenHandedOver" select="fhir:whenHandedOver/@value" />

        <div
            class="prsb-heading-banner medications-and-medical-devices">
            Medications and medical devices
        </div>
        <div class="prsb-content">
            <table>
                <tr>
                    <td class="nhs-pale-grey">Medication</td>
                    <td>
                        <xsl:value-of select="$medicationName"></xsl:value-of>
                    </td>
                </tr>
                <tr>
                    <td class="nhs-pale-grey">Days supply</td>
                    <td>
                        <xsl:value-of select="$supplyInteger"></xsl:value-of>
                    </td>
                </tr>
                <tr>
                    <td class="nhs-pale-grey">Patient instruction</td>
                    <td>
                        <xsl:value-of select="$patientInstruction"></xsl:value-of>
                    </td>
                </tr>
                <!-- <tr>
                    <td class="nhs-pale-grey">When prepared</td>
                    <td>
                        <xsl:value-of select="$whenPrepared"></xsl:value-of>
                    </td>
                </tr>
                <tr>
                    <td class="nhs-pale-grey">When handed over</td>
                    <td>
                        <xsl:value-of select="$whenHandedOver"></xsl:value-of>
                    </td>
                </tr> -->
            </table>
        </div>

    </xsl:template>

    <!-- Observations -->
    <xsl:template mode="observations" match="fhir:Observation">

        <!-- Observation coding -->
        <xsl:variable name="obsCode"
            select="fhir:code/fhir:coding/fhir:display/@value" />

        <!-- Effective date time -->
        <xsl:variable
            name="effectiveDateTime" select="fhir:effectiveDateTime/@value" />

        <!-- Issued -->
        <xsl:variable
            name="issued" select="fhir:issued/@value" />

        <!-- Body site -->
        <xsl:variable name="bodySite"
            select="fhir:bodySite/fhir:coding/fhir:display/@value" />

        <!-- Category -->
        <xsl:variable name="category"
            select="fhir:category/fhir:coding/fhir:display/@value" />

        <!-- Status -->
        <xsl:variable name="status"
            select="fhir:status/@value" />

        <div class="prsb-heading-banner observation">
            <strong>Observation</strong>
        </div>
        <div
            class="prsb-content">
            <table>

                <!-- code -->
                <tr>
                    <td class="nhs-pale-grey">Code term</td>
                    <td><xsl:value-of select="$obsCode"></xsl:value-of></td>
                </tr>

                <!-- effective date -->
                <!-- <tr>
                    <td class="nhs-pale-grey">Effective date</td>
                    <td><xsl:value-of select="$effectiveDateTime"></xsl:value-of></td>
                </tr> -->

                <!-- date -->
                <tr>
                    <td class="nhs-pale-grey">Date</td>
                    <td>
                        <xsl:value-of select="$issued"></xsl:value-of>
                    </td>
                </tr>

                <!-- category -->
                <!-- <tr>
                    <td class="nhs-pale-grey">Category</td>
                    <td><xsl:value-of select="$category"></xsl:value-of></td>
                </tr> -->

                <!-- status -->
                <!-- <tr>
                    <td class="nhs-pale-grey">Staus</td>
                    <td><xsl:value-of select="$status"></xsl:value-of></td>
                </tr> -->

                <!-- body site -->
                <xsl:if test="$bodySite">
                    <tr>
                        <td class="nhs-pale-grey">Body site</td>
                        <td>
                            <xsl:value-of select="$bodySite"></xsl:value-of>
                        </td>
                    </tr>
                </xsl:if>

                <!-- valueQuantity -->
                <xsl:if test="fhir:valueQuantity">
                    <tr>
                        <td class="nhs-pale-grey">Value</td>
                        <td>
                            <xsl:value-of select="fhir:valueQuantity/fhir:value/@value" />
                            <xsl:value-of select="fhir:valueQuantity/fhir:code/@value" />
                        </td>
                    </tr>
                </xsl:if>

                <!-- component -->
                <xsl:if test="fhir:component">
                    <xsl:for-each select="fhir:component">
                        <tr>
                            <td class="nhs-pale-grey">
                                <xsl:value-of select="fhir:code/fhir:coding/fhir:display/@value" />
                            </td>
                            <td>
                                <xsl:value-of select="fhir:valueQuantity/fhir:value/@value" />
                                <xsl:value-of select="fhir:valueQuantity/fhir:code/@value" />
                            </td>
                        </tr>
                    </xsl:for-each>
                </xsl:if>
            </table>
        </div>
    </xsl:template>

    <!-- Organisations -->
    <xsl:template mode="organisations" match="fhir:Organization">

        <!-- Organisation name -->
        <xsl:variable
            name="organisationName" select="fhir:name/@value"></xsl:variable>
        
        <div class="prsb-content">
            <table>
                <tr>
                    <td class="nhs-pale-grey">
                        <xsl:choose>
                            <xsl:when test="$organisationName">
                                <xsl:value-of select="$organisationName" />
                            </xsl:when>
                            <xsl:otherwise>
                                Not specified
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                    <td>
                        <ul>
                        <xsl:for-each select="fhir:identifier">
                            <li><xsl:value-of select="fhir:value/@value" /></li>
                        </xsl:for-each>
                        </ul>
                    </td>
                </tr>
            </table>
        </div>
    </xsl:template>

    <!-- Healthcare professionals -->
    <xsl:template mode="hcp" match="fhir:Practitioner">

        <!-- HCP family name -->
            <xsl:variable name="hcpFamilyName"
            select="fhir:name/fhir:family/@value"></xsl:variable>

        <!-- HCP given name -->
            <xsl:variable name="hcpGivenName"
            select="fhir:name/fhir:given/@value"></xsl:variable>

        <!-- HCP given name -->
            <xsl:variable name="hcpPrefix"
            select="fhir:name/fhir:prefix/@value"></xsl:variable>

            <div class="prsb-content">
                <table>
                    <tr>
                        <td class="nhs-pale-grey">
                            <xsl:choose>
                                <xsl:when test="$hcpPrefix">
                                    <xsl:value-of select="$hcpPrefix" />
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="$hcpGivenName" />
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="$hcpFamilyName" />
                                </xsl:when>
                                <xsl:otherwise>
                                    Not specified
                                </xsl:otherwise>
                            </xsl:choose>

                        </td>
                        <td>
                            <ul>
                            <xsl:for-each select="fhir:identifier">
                                <li><xsl:value-of select="fhir:value/@value" /></li>
                            </xsl:for-each>
                            </ul>
                        </td>
                    </tr>
                </table>
            </div>
    </xsl:template>

    <!-- Practitioner roles -->
    <xsl:template mode="practitioner-role" match="fhir:PractitionerRole">
        
        <!-- Practitioner ID -->
        <xsl:variable name="practitionerId"
        select="fhir:practitioner/fhir:reference/@value"></xsl:variable>

        <!-- Pracitioner role code -->
        <xsl:variable name="practitionerRoleCode"
        select="fhir:code/fhir:coding/fhir:code/@value"></xsl:variable>

        <!-- Pracitioner role name -->
        <xsl:variable name="practitionerRoleName"
        select="fhir:code/fhir:coding/fhir:display/@value"></xsl:variable>


        <div class="prsb-content">
            <table>
                <tr>
                    <td class="nhs-pale-grey">
                        Practitioner ID
                    </td>
                    <td>
                        <xsl:value-of select="$practitionerId" />
                    </td>
                </tr>
                <tr>
                    <td class="nhs-pale-grey">
                        Role
                    </td>
                    <td>
                        <xsl:value-of select="$practitionerRoleName" /> (<xsl:value-of select="$practitionerRoleCode" />)
                    </td>
                </tr>
            </table>
        </div>
    </xsl:template>

</xsl:stylesheet>