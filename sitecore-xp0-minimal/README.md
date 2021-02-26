# Sitecore 10 XP0 with xDB and ID Server disabled

An example repo for running Sitecore 10 XP0 topology on Docker. The build will layer in SPE, this is a minimum requirement for all our projects.

Additionally both xDB and ID Server are disabled. xConnect service instances are scaled down to 0 to save additional CPU/RAM for local development purposes. This provides a minimal development environment for most purposes.
