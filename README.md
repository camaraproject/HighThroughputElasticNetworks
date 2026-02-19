<a href="https://github.com/camaraproject/HighThroughputElasticNetworks/commits/" title="Last Commit"><img src="https://img.shields.io/github/last-commit/camaraproject/HighThroughputElasticNetworks?style=plastic"></a>
<a href="https://github.com/camaraproject/HighThroughputElasticNetworks/issues" title="Open Issues"><img src="https://img.shields.io/github/issues/camaraproject/HighThroughputElasticNetworks?style=plastic"></a>
<a href="https://github.com/camaraproject/HighThroughputElasticNetworks/pulls" title="Open Pull Requests"><img src="https://img.shields.io/github/issues-pr/camaraproject/HighThroughputElasticNetworks?style=plastic"></a>
<a href="https://github.com/camaraproject/HighThroughputElasticNetworks/graphs/contributors" title="Contributors"><img src="https://img.shields.io/github/contributors/camaraproject/HighThroughputElasticNetworks?style=plastic"></a>
<a href="https://github.com/camaraproject/HighThroughputElasticNetworks" title="Repo Size"><img src="https://img.shields.io/github/repo-size/camaraproject/HighThroughputElasticNetworks?style=plastic"></a>
<a href="https://github.com/camaraproject/HighThroughputElasticNetworks/blob/main/LICENSE" title="License"><img src="https://img.shields.io/badge/License-Apache%202.0-green.svg?style=plastic"></a>
<a href="https://github.com/camaraproject/HighThroughputElasticNetworks/releases/latest" title="Latest Release"><img src="https://img.shields.io/github/release/camaraproject/HighThroughputElasticNetworks?style=plastic"></a>
<a href="https://github.com/camaraproject/Governance/blob/main/ProjectStructureAndRoles.md" title="Sandbox API Repository"><img src="https://img.shields.io/badge/Sandbox%20API%20Repository-yellow?style=plastic"></a>

# HighThroughputElasticNetworks

Sandbox API Repository to describe, develop, document, and test the HighThroughputElasticNetworks Service API(s). The repository does not yet belong to a CAMARA Sub Project.

* API Repository [wiki page](https://lf-camaraproject.atlassian.net/wiki/x/wQAkAw)

## Scope

* Service APIs for “HighThroughputElasticNetworks” (see APIBacklog.md) <!-- Alternative for multiple APIs: "Service APIs for "HighThroughputElasticNetworks” -->
* The API provides the customer with the ability to:  
  * This API provides scheduling ability of huge data transmission in network. It can calculate load-balancing paths automatically with given time duration, total data amount and bandwidth limit, and satisfy huge data transmission requirements with dynamic and elastic bandwidth allocation algorithms, tidal-traffic-aware segment list adjustment and SRv6 multiple segment list technology.<br />This API is designed for large enterprises requiring efficient network bandwidth management. It dynamically adjusts and optimizes bandwidth utilization to handle high-volume data transmission scenarios such as video conferences, large file transfers, and cloud resource access. By leveraging advanced technologies, it ensures seamless and efficient data flow across different time periods. This API is ideal for organizations that need robust solutions to manage substantial data transfers, ensuring high performance and reliability in demanding network environments.<br/>This API is suitable for customers in industries with massive data transfer requirements, such as Cross-cloud backup, model training at intelligent compute centers, video editing, and scientific computing. For example, the Five-hundred-meter Aperture Spherical radio Telescope (FAST), located in GuiZhou province of China, could generate more than 10 PB of observational data per year. By calling this API, users can dynamically adjust bandwidth and elastically orchestrate network resources according to their specific requirements for bandwidth, latency, and file size. This capability facilitates the efficient and expedient transmission of large observational datasets within short timeframes. In subsequent applications of the API, developers can set multiple groups of input parameters as standard configuration files, enabling quick selection and application.<br /><br />Input:<br/>1. Bandwidth Requirement: Time-segmented bandwidth requirements (can include multiple time points)<br/>2. Bandwidth Requirement Type: Upload bandwidth, download bandwidth, two-way bandwidth Service<br/>3. Latency Requirement: Latency guarantee requirement range<br/>4. File Requirements: Size of files to be transmitted <br/>5. Guarantee Requirements: Bandwidth guarantee and load sharing requirements<br/><br />Output:<br/>1. Success or failure<br/>2. Estimation of transmission rate by time segment<br/>3. Estimated transmission duration,<br/>4. Statistical conclusions after successful transmission1. Estimation of transmission rate by time segment<br/>5. (optional) any conditions required for the operator to meet the request (e.g. a particular entry point to the network must be used).
* Describe, develop, document, and test the APIs
* Started: November 2024

<!-- CAMARA:RELEASE-INFO:START -->
<!-- The following section is automatically maintained by the CAMARA project-administration tooling: https://github.com/camaraproject/project-administration -->

## Release Information

The repository has no (pre)releases yet, work in progress is within the main branch.
<!-- CAMARA:RELEASE-INFO:END -->

## Contributing
* Meetings are held virtually
    * Schedule: !! tbd
    * [Registration / Join](https://wiki.camaraproject.org/x/TQAG) !! Update this link with your meeting registration/join link
    * Minutes: Access [meeting minutes] !! update this link to your wiki page using the "Share" link
* Mailing List
    * Subscribe / Unsubscribe to the mailing list of this Sub Project <https://lists.camaraproject.org/g/sp-hten>.
    * A message to the community of this Sub Project can be sent using <sp-hten@lists.camaraproject.org>.
