def build_encryption_config(event, context):
    # Initialize the JSON structure
    rules = {
        "Rules": [{
            "ApplyServerSideEncryptionByDefault": {
                "SSEAlgorithm": event['sse_algorithm']
            },
            "BucketKeyEnabled": event['bucket_key_enabled']
        }]
    }

    # Add KMSMasterKeyID only if it is present and not None
    if event.get('kms_master_key_id') is not None:
        rules["Rules"][0]["ApplyServerSideEncryptionByDefault"]["KMSMasterKeyID"] = event['kms_master_key_id']

    return rules
