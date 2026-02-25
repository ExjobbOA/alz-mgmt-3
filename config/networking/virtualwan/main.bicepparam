using '../../../platform/templates/networking/virtualwan/main.bicep'

var location          = readEnvironmentVariable('LOCATION_PRIMARY')
var locationSecondary = readEnvironmentVariable('LOCATION_SECONDARY', '')
var enableTelemetry   = bool(readEnvironmentVariable('ENABLE_TELEMETRY', 'true'))

param parLocations = [
  location
  locationSecondary
]
param parTags = {}
param parEnableTelemetry = enableTelemetry
param parGlobalResourceLock = {
  name: 'GlobalResourceLock'
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep Hub Networking Module.'
}

// Resource Group Parameters
param parVirtualWanResourceGroupNamePrefix = 'rg-alz-conn'
param parDnsResourceGroupNamePrefix = 'rg-alz-dns'
param parDnsPrivateResolverResourceGroupNamePrefix = 'rg-alz-dnspr'

// Virtual WAN Parameters
param vwan = {
  name: 'vwan-alz-${location}'
  location: location
  type: 'Standard'
  allowBranchToBranchTraffic: true
  lock: {
    kind: 'None'
    name: 'vwan-lock'
    notes: 'This lock was created by the ALZ Bicep Hub Networking Module.'
  }
}

// Virtual WAN Hub Parameters
param vwanHubs = [
  {
    hubName: 'vhub-alz-${location}'
    location: location
    addressPrefix: '10.0.0.0/22'
    allowBranchToBranchTraffic: true
    preferredRoutingGateway: 'ExpressRoute'
    azureFirewallSettings: {
      deployAzureFirewall: true
      name: 'afw-alz-${location}'
    }
    expressRouteGatewaySettings: {
      deployExpressRouteGateway: true
      name: 'ergw-alz-${location}'
      minScaleUnits: 1
      maxScaleUnits: 1
      allowNonVirtualWanTraffic: false
    }
    s2sVpnGatewaySettings: {
      deployS2sVpnGateway: false
      name: 's2s-alz-${location}'
      scaleUnit: 1
    }
    p2sVpnGatewaySettings: {
      deployP2sVpnGateway: false
      name: 'p2s-alz-${location}'
      scaleUnit: 1
      vpnServerConfiguration: {
        vpnAuthenticationTypes: ['AAD']
      }
      vpnClientAddressPool: {
        addressPrefixes: ['172.16.0.0/24']
      }
    }
    ddosProtectionPlanSettings: {
      deployDdosProtectionPlan: true
      name: 'ddos-alz-${location}'
      tags: {}
    }
    dnsSettings: {
      deployPrivateDnsZones: true
      deployDnsPrivateResolver: true
      privateDnsResolverName: 'dnspr-alz-${location}'
    }
    bastionSettings: {
      deployBastion: true
      name: 'bas-alz-${location}'
      sku: 'Standard'
    }
    sideCarVirtualNetwork: {
      name: 'vnet-sidecar-alz-${location}'
      sidecarVirtualNetworkEnabled: true
      addressPrefixes: [
        '10.0.4.0/22'
      ]
    }
  }
  {
    hubName: 'vhub-alz-${locationSecondary}'
    location: locationSecondary
    addressPrefix: '10.1.0.0/22'
    allowBranchToBranchTraffic: true
    preferredRoutingGateway: 'ExpressRoute'
    azureFirewallSettings: {
      deployAzureFirewall: true
      name: 'afw-alz-${locationSecondary}'
    }
    expressRouteGatewaySettings: {
      deployExpressRouteGateway: true
      name: 'ergw-alz-${locationSecondary}'
      minScaleUnits: 1
      maxScaleUnits: 1
      allowNonVirtualWanTraffic: false
    }
    s2sVpnGatewaySettings: {
      deployS2sVpnGateway: false
      name: 's2s-alz-${locationSecondary}'
      scaleUnit: 1
    }
    p2sVpnGatewaySettings: {
      deployP2sVpnGateway: false
      name: 'p2s-alz-${locationSecondary}'
      scaleUnit: 1
      vpnServerConfiguration: {
        vpnAuthenticationTypes: ['AAD']
      }
      vpnClientAddressPool: {
        addressPrefixes: ['172.16.1.0/24']
      }
    }
    ddosProtectionPlanSettings: {
      deployDdosProtectionPlan: false
    }
    dnsSettings: {
      deployPrivateDnsZones: true
      deployDnsPrivateResolver: true
      privateDnsResolverName: 'dnspr-alz-${locationSecondary}'
      privateDnsZones: [
        'privatelink.{regionName}.azurecontainerapps.io'
        'privatelink.{regionName}.kusto.windows.net'
        'privatelink.{regionName}.azmk8s.io'
        'privatelink.{regionName}.prometheus.monitor.azure.com'
        'privatelink.{regionCode}.backup.windowsazure.com'
      ]
    }
    bastionSettings: {
      deployBastion: true
      name: 'bas-alz-${locationSecondary}'
      sku: 'Standard'
    }
    sideCarVirtualNetwork: {
      name: 'vnet-sidecar-alz-${locationSecondary}'
      sidecarVirtualNetworkEnabled: true
      addressPrefixes: [
        '10.1.4.0/22'
      ]
    }
  }
]
